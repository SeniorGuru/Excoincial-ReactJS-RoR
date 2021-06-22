# encoding: UTF-8
# frozen_string_literal: true

module APIv2
  class Withdraws < Grape::API
    helpers APIv2::NamedParams

    before { authenticate! }
    before { withdraws_must_be_permitted! }

    desc 'List your withdraws as paginated collection.', scopes: %w[history],
      is_array: true,
      success: APIv2::Entities::Withdraw
    params do
      optional :currency, type: String,  values: -> { Currency.enabled.codes(bothcase: true) }, desc: -> { "Any supported currencies: #{Currency.enabled.codes(bothcase: true).join(',')}." }
      optional :page,     type: Integer, default: 1,   integer_gt_zero: true, desc: 'Page number (defaults to 1).'
      optional :limit,    type: Integer, default: 100, range: 1..1000, desc: 'Number of withdraws per page (defaults to 100, maximum is 1000).'
    end
    get '/withdraws' do
      currency = Currency.find(params[:currency]) if params[:currency].present?

      current_user
        .withdraws
        .order(id: :desc)
        .tap { |q| q.where!(currency: currency) if currency }
        .page(params[:page])
        .per(params[:limit])
        .tap { |q| present q, with: APIv2::Entities::Withdraw }
    end

    # TODO!!! unexpose operation from unpermitted to issue api keys with  scope vendasity
    desc 'List your VENDESCROW withdraws as paginated collection.', scopes: %w[history],
      is_array: true,
      success: APIv2::Entities::Withdraw
    params do
      optional :page,     type: Integer, default: 1,   integer_gt_zero: true, desc: 'Page number (defaults to 1).'
      optional :limit,    type: Integer, default: 100, range: 1..1000, desc: 'Number of withdraws per page (defaults to 100, maximum is 1000).'
    end
    get '/withdraws/vendescrow' do
      error!(error: "Operation restricted to officers only.", status: 422) unless vendasity_inscope?
      currency = Currency.find('vendescrow')

      current_user
        .withdraws
        .order(id: :desc)
        .tap { |q| q.where!(currency: currency) if currency }
        .page(params[:page])
        .per(params[:limit])
        .tap { |q| present q, with: APIv2::Entities::Withdraw }
    end

    # TODO!!! unexpose operation from unpermitted to issue api keys with  scope vendasity
    desc 'Creates new withdraw.' do
      detail 'Creates new withdraw. Restricted to company officers only. Resctricted to VENDESCROW currency only. <br>' \
             'Fiat: money are immediately locked, withdraw state is set to "submitted", company officer ' \
                   'will validate withdraw later against suspected activity, and assign state to "rejected" or "accepted". ' \
                   'The processing will not begin automatically. The processing may be initiated manually from admin ' \
                   'panel or by PUT /api/v2/withdraws/vendescrow/action. '
    end
    params do
      requires :uid,      type: String, allow_blank: false,
                          desc: 'The shared user ID. Must be a string of "ID" tag and 10 characters [0-9a-fA-F]',
                          regexp: /^ID[0-9a-fA-F]{10}$/
      requires :aid,      type: String, allow_blank: false,
                          desc: 'The Vendasity engine application ID for item buy/bid. Must be a string of 6 characters [0-9a-fA-F]',
                          regexp: /^[0-9a-fA-F]{6}$/
      requires :oid,      type: String, allow_blank: false,
                          desc: 'The ID of VENDESCROW buy order placed in order to buy/bid for an item. Must be a string of 6 characters [0-9a-fA-F]',
                          regexp: /^[0-9a-fA-F]{6}$/
      requires :ots,      type: Integer, allow_blank: false,
                          desc: 'The timestamp of buy/bid order for item of Vendasity. Must be a unix timestamp, ' \
                                'e.g. 1562672471 which stands for 2019-07-09 11:41:11 at UTC',
                          regexp: /^[0-9]{10}$/
#      optional :tid,      type: String, desc: 'The shared transaction ID. Must not exceed 64 characters. Peatio will generate one automatically unless supplied.'
      requires :rid,      type: String, allow_blank: false, desc: 'The beneficiary ID or wallet address on the Blockchain.'
      requires :amount,   type: BigDecimal, desc: 'The amount to release escrow.'
      requires :reason,   type: String, values: %w[delivered refund reward unbid],
                          desc: 'The reason to credit receiver. ' \
                                'arrive: purchased item is delivered successfully, relese the funds from the escrow. ' \
                                'refund: purchased item delivery terms failed or specifications violated, refund from the escrow. ' \
                                'reward: release reward according to referral program, release from the escrow. ' \
                                'outbid: bid for an item is canceled or is outbid, refund from the escrow. '
      optional :action,   type: String, values: %w[process], desc: 'The action to perform.'
    end
    post '/withdraws/vendescrow/new' do
      error!(error: "Operation restricted to officers only.", status: 422) unless vendasity_inscope?
      currency = Currency.find('vendescrow')
      receiver_account ||= Member.find_by(code: params[:rid])
      receiver_account ||= Member.find_by(email: params[:rid])
      receiver_account ||= Member.find_by(sn: params[:rid])
      receiver_account ||= PaymentAddress.find_by(address: params[:rid]).account.member if params[:rid][0..1]=="0x" rescue {}
      receiver_account ||= Authentication.find_by(provider: :barong, uid: params[:rid])&.member
      if receiver_account.nil?
        error!(error: "Account with given rid doesn\'t exist.", status: 422)
      else
        unless receiver_account.code.present?
          receiver_account.update code: Authentication.find_by(provider: :barong, member_id: receiver_account.id).uid
        end
      end
      member   = Authentication.find_by(provider: :barong, uid: params[:uid])&.member
      if member.present? and !member.code.present?
        member.update code: params[:uid]
      end

      withdraw = "withdraws/#{currency.type}".camelize.constantize.new \
        amount:         params[:amount].to_f,
        sum:            params[:amount].to_f,
        member:         member,
        currency:       currency,
        tid:            params[:ots].to_s + params[:aid].to_s + params[:oid].to_s + params[:reason].to_s,
        rid:            receiver_account.code

      if withdraw.amount > member.accounts.find_by(currency_id: currency.id).balance
        body errors: ("Insufficent VENDESCROW balance, required #{'%f' % withdraw.amount}, " +
          " available #{'%f' % member.accounts.find_by(currency_id: currency.id).balance}, " +
          " locked #{'%f' % member.accounts.find_by(currency_id: currency.id).locked}")
        status 422
      elsif withdraw.save
        withdraw.with_lock { withdraw.submit! }
        perform_action(withdraw, params[:action]) if params[:action]
        present withdraw, with: APIv2::Entities::Withdraw
      else
        body errors: withdraw.errors.full_messages
        status 422
      end
    end

    # TODO!!! unexpose operation from unpermitted to issue api keys with  scope vendasity
    desc 'Performs action on withdraw.' do
      detail '"process"  system will lock the money, check for suspected activity, try validate ' \
                        'recipient address, and initiate the processing of the withdraw. ' \
             '"cancel"   system will mark withdraw as canceled, and unlock the money. '
    end
    params do
      requires :tid,    type: String, desc: 'The shared transaction ID.'
      requires :action, type: String, values: %w[process cancel], desc: 'The action to perform.'
    end
    put '/withdraws/vendescrow/action' do
      error!(error: "Operation restricted to officers only.", status: 422) unless vendasity_inscope?
      record = Withdraw.find_by!(params.slice(:tid))
      perform_action(record, params[:action])
      present record, with: APIv2::Entities::Withdraw
    end
  end
end
