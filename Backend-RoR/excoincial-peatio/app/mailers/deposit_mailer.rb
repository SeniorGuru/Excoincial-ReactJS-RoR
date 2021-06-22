class DepositMailer < ApplicationMailer
  include MailerHelper

  after_action :set_unsubscribe_header

  def accepted(deposit_id)
    @deposit = Deposit.find deposit_id
    @member = @deposit.member
    if @deposit.nil?
      Rails.logger.debug { " deposit_id #{deposit_id} found #{@deposit.inspect}" }
    end
    @unsubscribe = "#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('AUTH_URL_HOST')}/unsubscribe?unsubscribe_token=" +
      Rails.application.message_verifier(:unsubscribe).generate(@deposit.member.code)
    mail to: @deposit.member.email
  end

  def escrow_released(deposit_id)
    @deposit = Deposit.find deposit_id
    @member = @deposit.member
    @sender = Withdraw.find_by(tid: @deposit.tid).member
    if @deposit.nil?
      Rails.logger.debug { " deposit_id #{deposit_id} found #{@deposit.inspect}" }
    end
    @unsubscribe = "#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('AUTH_URL_HOST')}/unsubscribe?unsubscribe_token=" +
      Rails.application.message_verifier(:unsubscribe).generate(@deposit.member.code)
    mail to: @deposit.member.email
  end

end
