# frozen_string_literal: true

# Verify recaptcha
class RecaptchaVerifier
  def self.verify(response, remote_ip, recaptcha_client=GoogleRecaptcha)
    new(response, remote_ip, recaptcha_client).verify
  end

  def initialize(response, remote_ip, recaptcha_client)
    @recaptcha_response = response
    @remote_ip          = remote_ip
    @recaptcha_client   = recaptcha_client.new
  end

  def verify
    return false unless recaptcha_response
    recaptcha_client.verify_recaptcha(response: recaptcha_response, remoteip: remote_ip)
  rescue
    false
  end

  private

  attr_reader :recaptcha_client, :recaptcha_response, :remote_ip
end
