# encoding: UTF-8
# frozen_string_literal: true

require_relative 'validations'

module APIv2
  class Deposits < Grape::API
    helpers ::APIv2::NamedParams

    before { authenticate! }
    before { deposits_must_be_permitted! }

    desc 'Get your deposits history.',
    is_array: true,
    success: APIv2::Entities::Deposit

    params do
      optional :currency, type: String, values: -> { Currency.enabled.codes(bothcase: true) }, desc: -> { "Currency value contains #{Currency.enabled.codes(bothcase: true).join(',')}" }
      optional :limit, type: Integer, range: 1..100, default: 3, desc: "Set result limit."
      optional :state, type: String, values: -> { Deposit::STATES.map(&:to_s) }
    end
    get "/deposits" do
      deposits = current_user.deposits.includes(:currency).limit(params[:limit]).recent
      deposits = deposits.with_currency(params[:currency]) if params[:currency]
      deposits = deposits.where(aasm_state: params[:state]) if params[:state].present?
      present deposits, with: APIv2::Entities::Deposit
    end

    # TODO!!! unexpose operation from unpermitted to issue api keys with  scope vendasity
    desc 'List your VENDESCROW deposits as paginated collection.', scopes: %w[history],
      is_array: true,
      success: APIv2::Entities::Deposit
    params do
      optional :page,     type: Integer, default: 1,   integer_gt_zero: true, desc: 'Page number (defaults to 1).'
      optional :limit,    type: Integer, default: 100, range: 1..1000, desc: 'Number of withdraws per page (defaults to 100, maximum is 1000).'
      optional :state,    type: String, values: -> { Deposit::STATES.map(&:to_s) }
    end
    get '/deposits/vendescrow' do
      error!(error: "Operation restricted to officers only.", status: 422) unless vendasity_inscope?
      currency = Currency.find('vendescrow')

      current_user
        .deposits
        .order(id: :desc)
        .tap { |q| q.where!(currency: currency) if currency }
        .tap { |q| q.where!(aasm_state: params[:state]) if params[:state].present? }
        .page(params[:page])
        .per(params[:limit])
        .tap { |q| present q, with: APIv2::Entities::Deposit }
    end


    desc 'Get details of specific deposit.' do
      success APIv2::Entities::Deposit
    end
    params do
      requires :txid
    end
    get "/deposit" do
      deposit = current_user.deposits.find_by(txid: params[:txid])
      raise DepositByTxidNotFoundError, params[:txid] unless deposit

      present deposit, with: APIv2::Entities::Deposit
    end

    desc 'Returns deposit address for account you want to deposit to. ' \
         'The address may be blank because address generation process is still in progress. ' \
         'If this case you should try again later.',
          success: APIv2::Entities::Deposit
    params do
      requires :currency, type: String, values: -> { Currency.coins.enabled.codes(bothcase: true) }, desc: 'The account you want to deposit to.'
      given :currency do
        optional :address_format, type: String, values: -> { %w[legacy cash] }, validate_currency_address_format: true, desc: 'Address format legacy/cash'
      end
    end
    get '/deposit_address' do
      current_user.ac(params[:currency]).payment_address.yield_self do |pa|
        { currency: params[:currency], address: params[:address_format] ? pa.format_address(params[:address_format]) : pa.address }
      end
    end

    desc 'Returns new deposit address for account you want to deposit to. ' \
         'The address may be blank because address generation process is still in progress. ' \
         'If this case you should try again later. ',
         success: APIv2::Entities::Deposit
    params do
      requires :currency, type: String, values: -> { Currency.coins.enabled.codes(bothcase: true) }, desc: 'The account you want to deposit to.'
    end
    post '/deposit_address', hidden: true do
      error!(error: 'This method is currently unavailable.', status: 403)
      current_user.ac(params[:currency]).payment_address!.yield_self do |pa|
        { currency: params[:currency], address: pa.address }
      end
    end
  end
end
