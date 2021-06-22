class WithdrawMailer < ApplicationMailer
  include MailerHelper

  after_action :set_unsubscribe_header

  def accepted(withdraw_id)
    @withdraw = Withdraw.find withdraw_id
    @member = @withdraw.member
    @unsubscribe = "#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('AUTH_URL_HOST')}/unsubscribe?unsubscribe_token=" +
      Rails.application.message_verifier(:unsubscribe).generate(@withdraw.member.code)
    mail(to: @withdraw.member.email, subject: "Withdrawal confirmation")
  end

  def escrow_released(withdraw_id)
    @withdraw = Withdraw.find withdraw_id
    @member = @withdraw.member
    @receiver = Member.find_by code: @withdraw.parse_tx[:uid]
    @unsubscribe = "#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('AUTH_URL_HOST')}/unsubscribe?unsubscribe_token=" +
      Rails.application.message_verifier(:unsubscribe).generate(@withdraw.member.code)
    mail(to: @withdraw.member.email, subject: "Escrow release notification")
  end
end
