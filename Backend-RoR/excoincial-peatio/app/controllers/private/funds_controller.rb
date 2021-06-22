# encoding: UTF-8
# frozen_string_literal: true

module Private
  class FundsController < BaseController
    include CurrencyHelper

    layout 'funds'

    before_action :trading_must_be_permitted!

    def index
      @currencies        = Currency.enabled.sort
      @withdraws         = current_user.withdraws
      accounts          = current_user.accounts.enabled.includes(:currency)
      @deposits          = current_user.deposits.includes(:currency, :blockchain)
      @recordsTotal = accounts.count.to_i
      gon.jbuilder
    end

    def funds_json
      if params[:hide].present? && params[:hide] == "true"
        accounts = current_user.accounts.enabled.includes(:currency)
        @accounts = []
        accounts.each do |account|
          unless (account.balance + account.locked) == 0.0
            @accounts << account
          end
        end
        @recordsTotal = @accounts.count.to_i
      else
        accounts          = current_user.accounts.enabled.includes(:currency)
        @recordsTotal = accounts.count.to_i
        if params[:length].present?
          @accounts = accounts.offset(params[:start].to_i).limit(params[:length].to_i)
        else
          @accounts = accounts.offset(params[:start].to_i)
        end
      end
      accounts_json = @accounts.map do |account|
        [account.currency.id.upcase,
        account.balance,
        account.locked,
        (account.balance + account.locked),
        "<img class='funds-currency-icon' src=#{account.currency.icon_url}>",
        account.currency.name,
         "<a class='btn btn-primary btn-xs m-t-9' href='/deposits/#{account.currency.id}'>Deposit</a>"+
                              "<a class='btn btn-default btn-xs m-t-9' href='/withdraws/#{account.currency.id}'>Withdraw</a>"]
      end
      render json: { accounts_json: accounts_json,
       draw: @draw,
       recordsTotal: @recordsTotal,
       recordsFiltered: @recordsTotal }
    end

    helper_method :currency_icon_url

    def gen_address
      current_user.accounts.enabled.each(&:payment_address)
      render nothing: true
    end
  end
end

