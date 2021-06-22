# encoding: UTF-8
# frozen_string_literal: true

module Private
  class HistoryController < BaseController

    layout 'history'
    helper_method :tabs

    def account
      @deposits = Deposit.where(member: current_user)
                      .includes(:currency, :blockchain)
      @withdraws = Withdraw.where(member: current_user, aasm_state: :succeed)#, type: "Withdraws::Coin")
                      .includes(:currency, currency: :blockchain)

      begin
        @transactions = (@deposits + @withdraws).sort_by do |t|
          -t.created_at.to_i
        end
        @transactions = Kaminari.paginate_array(@transactions).page(params[:page]).per(20)
      rescue => e
        Rails.logger.error { "Member id=#{current_user.id} failed to fetch account transactions.\nparams #{params}" }
        report_exception(e)
        Rails.logger.debug { @deposits.first.inspect }
        Rails.logger.debug { Withdraw.where(member: current_user, aasm_state: :succeed)
            .includes(:currency, currency: :blockchain).limit(1)
            .inspect }
        Rails.logger.debug { @market.inspect }
        @transactions = Kaminari.paginate_array([]).page(params[:page]).per(20)
      end
    end

    def trades
      @trades = current_user.trades
        .includes(:market)
        .order('id desc').page(params[:page]).per(20)
    end

    def orders
      @orders = current_user.orders.order("id desc").page(params[:page]).per(20)
    end

    def open_orders
      @orders = current_user.orders.where(state: :wait).order("id desc").page(params[:page]).per(20)
    end

    private

    def tabs
      { order: ['header.order_history', order_history_path],
        trade: ['header.trade_history', trade_history_path],
        account: ['header.account_history', account_history_path],
        open_order: ['header.open_order_history', open_order_history_path] }
    end

  end
end
