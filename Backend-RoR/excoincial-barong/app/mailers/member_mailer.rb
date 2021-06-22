class MemberMailer < ApplicationMailer
  include MailerHelper

  default from: ENV.fetch('SENDER_NAME', 'barong').downcase + '-noreply' + '<' + ENV.fetch('SENDER_EMAIL', 'noreply@barong.io') + '>'

  after_action :set_unsubscribe_header

  layout 'mailer'

  def shared_defines(account)
    @member = Account.find_by(uid: account.uid)
    @lock_period = time_ago_in_words(
      ( ENV.fetch('UNLOCK_IN',1440).to_i.minutes.ago+1.minute ).to_time
    )
    @unsubscribe = "#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('AUTH_URL_HOST')}/unsubscribe?unsubscribe_token=" +
      Rails.application.message_verifier(:unsubscribe).generate(account.uid)
  end

  def kyc_complete(account,new_profile_url,new_document_url)
    @new_profile = new_profile_url
    @new_document = new_document_url
    shared_defines(account)
    mail(to: account.email, subject: "KYC submitted")
  end
end
