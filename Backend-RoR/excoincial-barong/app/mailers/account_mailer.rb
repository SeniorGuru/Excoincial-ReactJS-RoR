# frozen_string_literal: true

class AccountMailer < Devise::Mailer
  include SkipEmails
  require 'action_view'
  require 'action_view/helpers'
  include ActionView::Helpers::DateHelper
  include MailerHelper

  default from: ENV.fetch('SENDER_NAME', 'barong').downcase + '-noreply' + '<' + ENV.fetch('SENDER_EMAIL', 'noreply@barong.io') + '>'

  after_action :set_unsubscribe_header

  layout 'mailer'

  def shared_defines(record)
    @member = Account.find_by(uid: record.uid) 
    @lock_period = time_ago_in_words( ( ENV.fetch('UNLOCK_IN',1440).to_i.minutes.ago+1.minute ).to_time )
    @unsubscribe = "#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('AUTH_URL_HOST')}/unsubscribe?unsubscribe_token=" +
      Rails.application.message_verifier(:unsubscribe).generate(record.uid)
  end

  def confirmation_instructions(record, token, opts = {})
    shared_defines(record)
    send_email_if_enabled { super }
  end

  def reset_password_instructions(record, token, opts = {})
    EventAPI.notify(
      'system.account.reset_password_token',
      uid: record.uid,
      email: record.email,
      token: token
    )
    shared_defines(record)
    send_email_if_enabled { super }
  end

  def unlock_instructions(record, token, opts = {})
    EventAPI.notify(
      'system.account.unlock_token',
      uid: record.uid,
      email: record.email,
      failed_attempts: record.failed_attempts,
      token: token
    )
    @unlock_at = (record.locked_at + ENV.fetch('UNLOCK_IN',1440).to_i)
    @unlock_from_now = ( record.locked_at.to_time < ENV.fetch('UNLOCK_IN',1440).to_i.minutes.ago ) ?
      Devise::TimeInflector.time_ago_in_words(
        Time.now + (ENV.fetch('UNLOCK_IN',1440).minutes.ago - record.locked_at.to_time)
 ) : nil
    shared_defines(record)
    send_email_if_enabled { super }
  end

  def email_changed(record, opts = {})
    shared_defines(record)
    send_email_if_enabled { super }
  end

  def password_change(record, opts = {})
    @password_change = true
    shared_defines(record)
    send_email_if_enabled { super }
  end
end
