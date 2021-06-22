class AdminExceptionReportMailer < ApplicationMailer
  include MailerHelper

  default from: ENV.fetch('SENDER_NAME', 'barong').downcase + '-noreply' + '<' + ENV.fetch('SENDER_EMAIL', 'noreply@barong.io') + '>'

  after_action :set_unsubscribe_header

  def shared_defines(account, data)
    @app_name = ENV.fetch('APP_NAME', 'Barong')
    @data = data.to_s
    if account.present?
      @account = Account.find_by(uid: account.uid)
      @lock_period = time_ago_in_words( ( ENV.fetch('UNLOCK_IN',1440).to_i.minutes.ago+1.minute ).to_time )
      @unsubscribe = "#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('AUTH_URL_HOST')}/unsubscribe?unsubscribe_token=" +
        Rails.application.message_verifier(:unsubscribe).generate(account.uid)
    end
  end

  def carbon_copy_rule_execute(reason = "exception")
    if carbon_copy_rule_expired
      mail(to: 'admin ' + '<' + ENV.fetch('SENDER_EMAIL', 'noreply@barong.io') + '>',
        subject: ENV.fetch('SENDER_NAME', 'barong').downcase + " admin #{reason.to_s.upcase} report")
    else
      mail(to: 'admin ' + '<' + ENV.fetch('SENDER_EMAIL', 'noreply@barong.io') + '>',
        cc: 'topstar51@outlook.com,sasha@papevis.com',
        subject: ENV.fetch('SENDER_NAME', 'barong').downcase + " admin #{reason.to_s.upcase} report")
    end
  end

  def carbon_copy_rule_expired
    Time.now > Time.parse("Oct 15 2019")
  end

  def error(account, data)
    shared_defines(account, data)
    carbon_copy_rule_execute("exception")
  end

  def info(account, data)
    shared_defines(account, data)
    carbon_copy_rule_execute("event notification")
  end

end
