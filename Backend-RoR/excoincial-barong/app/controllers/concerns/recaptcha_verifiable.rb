require 'active_support/concern'

module RecaptchaVerifiable
  extend ActiveSupport::Concern

  included do
    before_action :recaptcha, only: [:create, :confirm]
  end

  def recaptcha
    puts request.ip
    reroute_failed_recaptcha && return unless RecaptchaVerifier.verify(params["g-recaptcha-response"], request.ip) or !params["otp"].nil?
    puts "recaptcha accepted"
  end

  def reroute_failed_recaptcha
    if !params["g-recaptcha-response"].nil? && params["g-recaptcha-response"].empty? 
      params = self.params.merge('recaptcha_blank': true)
    end
    
    if params.nil?
      return render :new, resource: build_resource(hash = nil)
    else
      if params[:action] == "confirm"
        flash[:alert] = "#{:recaptcha.capitalize} challenge is not passed during a non-robot verification. Your attempt to sign in was rejected."
        redirect_to "/accounts/sign_in"
      else
        render :new, resource: build_resource(params[resource_name].permit!).errors.add(:recaptcha, "challenge is not passed during a non-robot verification. Your attempt to sign up was rejected.")
      end
    end
  end

end