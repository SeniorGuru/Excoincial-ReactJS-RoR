# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  include SkipEmails
  require 'action_view'
  require 'action_view/helpers'
  include ActionView::Helpers::DateHelper
  include MailerHelper

  helper :application

  default from: ENV.fetch('SENDER_NAME', 'barong').downcase + '-noreply' + '<' + ENV.fetch('SENDER_EMAIL', 'noreply@barong.io') + '>'

  after_action :set_unsubscribe_header

  layout 'mailer'

  def mail(options)
    send_email_if_enabled { super }
  end
end
