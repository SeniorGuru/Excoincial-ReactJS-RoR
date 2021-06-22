# encoding: UTF-8
# frozen_string_literal: true

module Private
  class DepositsController < BaseController
    before_action :deposits_must_be_permitted!
    protect_from_forgery :except => [:create_payeer]

    layout 'funds'

    def gen_address
      current_user.ac(currency).payment_address
      head 204
    end

    def destroy
      record = current_user.deposits.find(params[:id]).lock!
      if record.cancel!
        head 204
      else
        head 422
      end
    end

    def show
      if currency.fiat?
        @txid = "PG#{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}#{Time.now.to_i}"          
        return render "fiat_show", layout: "fiat_funds"
      end
      begin
        @deposit_address = current_user.ac(currency).payment_address
      rescue => e
        Rails.logger.error { "current_user: " + current_user.inspect }
        Rails.logger.error { "currency: " + currency.inspect }
        Rails.logger.error { current_user.ac(currency).inspect }
        report_exception e
        raise e
      end
    end

    def create_payment
      d = Deposit.new(member_id: current_user.id, amount: params[:amount].to_f, currency: currency, type: "Deposits::Fiat", txid: params[:txid], address: params[:address])
      d.save
      respond_to do |format|
        format.json { head :ok }
      end
    end

    private

    def currency
      @currency ||= Currency.enabled.find(params[:currency])
    end

  end
end
