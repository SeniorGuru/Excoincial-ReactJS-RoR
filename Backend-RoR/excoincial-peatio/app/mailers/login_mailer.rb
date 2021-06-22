class LoginMailer < ApplicationMailer
  require 'action_view'
  require 'action_view/helpers'
  include ActionView::Helpers::DateHelper
  include MailerHelper

  after_action :set_unsubscribe_header

  def shared_defines(member_id,browser,city,ip)
    @member = Member.find(member_id)
    @ip = ip
    @city = city
    @browser = browser
    @lock_period = time_ago_in_words( ( ENV.fetch('UNLOCK_IN',1440).to_i.minutes.ago+1.minute ).to_time )
    @unsubscribe = "#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('AUTH_URL_HOST')}/unsubscribe?unsubscribe_token=" +
      Rails.application.message_verifier(:unsubscribe).generate(@member.code)
  end

  def browser_mail(member_id, browser, city, ip, session_id, login_referer_path = nil)
    shared_defines member_id, browser, city, ip
    @session_id = session_id
    @login_referer_path = login_referer_path.nil? ? "&login_referer_path=%2Ftrading" : "&login_referer_path=#{login_referer_path}"
    mail(to: @member.email, subject: "Confirm log in from a new browser")
  end

  def diff_ip_mail(member_id, browser, city, ip, session_id, login_referer_path = nil)
    shared_defines member_id, browser, city, ip
    @session_id = session_id
    @login_referer_path = login_referer_path.nil? ? "&login_referer_path=%2Ftrading" : "&login_referer_path=#{login_referer_path}"
    mail(to: @member.email, subject: "Confirm log in from a new device")
  end

  def successful_login(member_id,browser,city,ip)
    shared_defines member_id, browser, city, ip
    mail(to: @member.email, subject: "Successful Login")
  end

  def successful_ip_verification(member_id,browser,city,ip)
    shared_defines member_id, browser, city, ip
    mail(to: @member.email, subject: "Successful IP Verification")
  end
end
