# frozen_string_literal: true

class ProfileReviewMailer < ApplicationMailer
  include MailerHelper

  default from: ENV.fetch('SENDER_NAME', 'barong').downcase + '-noreply' + '<' + ENV.fetch('SENDER_EMAIL', 'noreply@barong.io') + '>'

  after_action :set_unsubscribe_header

  def shared_defines(account)
    @member = Account.find_by(uid: account.uid)
    @lock_period = time_ago_in_words(
      ( ENV.fetch('UNLOCK_IN',1440).to_i.minutes.ago+1.minute ).to_time
    )
    @unsubscribe = "#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('AUTH_URL_HOST')}/unsubscribe?unsubscribe_token=" +
      Rails.application.message_verifier(:unsubscribe).generate(account.uid)
  end

  def approved(account)
    @profile = account.profile
    @app_name = ENV.fetch('APP_NAME', 'Barong')
    shared_defines(account)
    mail(to: account.email, subject: 'Your identity was approved')
  end

  def rejected(account)
    @profile = account.profile
    @app_name = ENV.fetch('APP_NAME', 'Barong')
    shared_defines(account)
    mail(to: account.email, subject: 'Your identity was rejected')
  end
end
