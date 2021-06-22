# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  #include RecaptchaVerifiable
  prepend_before_action :allow_params_authentication!, only: [:create]
  prepend_before_action :twofactor_verify, if: :otp_enabled?, only: :create

  def new
    flash.clear
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  def confirm
    return redirect_to(action: :new, login_referer_path: ENV["login_referer_path"]) if resource_params[:email].blank?

    # self.resource = resource_class.new(sign_in_params)
    # clean_up_passwords(resource)
    account = Account.kept.find_by(email: resource_params[:email])
    if account.state == "banned"
      flash[:alert] = 'Your Account is deactivated by company officer. Please contact Admin for reactivation'
      return redirect_to new_account_session_path
    end
    unless account.locked_at.nil?
      flash[:alert] = 'Your Account is deactivated on your request or due to many failed login attempts. ' \
        'If you did not receive unlock instructions please apply for resending'
      return redirect_to new_account_unlock_path, login_referer_path: ENV["login_referer_path"]
    end
    unless account
      flash[:alert] = 'Invalid Email'
      return redirect_to new_account_session_path, login_referer_path: ENV["login_referer_path"]
    end

    unless account.valid_for_authentication?{account.valid_password? resource_params[:password]}
      flash[:alert] = 'Invalid Password'
      return redirect_to new_account_session_path, login_referer_path: ENV["login_referer_path"]
    end
    if account.twofactor_enabled?
      session[:password] = resource_params[:password]
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      @otp_enabled = account.otp_enabled
      @email_otp = account.email_otp
      @sms_otp = account.sms_otp
      return render action: :confirm
    else
      login_history(account)
      warden.set_user(account, scope: :account)
      if ENV["login_referer_path"].nil?
        Rails.logger.debug { "\tlogin_referer_path #{ENV['login_referer_path']}" }
        return redirect_to after_sign_in_path_for(account)
      else
        Rails.logger.debug { "\tlogin_referer_path #{ENV['login_referer_path']}" }
        return redirect_to "#{after_sign_in_path_for(resource)}?#{Hash[:login_referer_path, ENV['login_referer_path']].to_query}"
      end
    end


    # self.resource = warden.authenticate!(auth_options)
    #
    #
    # @otp_enabled = otp_enabled?
    # if @otp_enabled == true
    #   sign_out
    #   @session_secret = resource_params[:password]
    #   render action: :confirm
    # else
    #   set_flash_message!(:notice, :signed_in)
    #   sign_in(resource_name, resource)
    #   yield resource if block_given?
    #   redirect_to '/auth/barong'
    #
    #   # respond_with resource, location: after_sign_in_path_for(resource)
    # end
  end

  def create
    # self.resource = warden.authenticate!(auth_options)
    account = Account.kept.find_by(email: resource_params[:email])
    redirect_to new_account_session_path + "?login_referer_path=" + URI(request.referer).path unless account.valid_password? session[:password]
    session[:password] = nil
    self.resource = account
    set_flash_message!(:notice, :signed_in)

    sign_in(resource_name, resource)
    yield resource if block_given?
    login_history(account)
    if ENV["login_referer_path"].nil?
      Rails.logger.debug { "\tlogin_referer_path #{ENV['login_referer_path']}" }
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      Rails.logger.debug { "\tlogin_referer_path #{ENV['login_referer_path']}" }
      respond_with resource, location: "#{after_sign_in_path_for(resource)}?#{Hash[:login_referer_path, ENV['login_referer_path']].to_query}"
    end
  end

  # DELETE /resource
  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    respond_with_navigational(resource){ redirect_to "#{params[:logout_referer_path].nil? ? request.referer : params[:logout_referer_path]}?reason=signed_out" }
  end

private

  def find_browser
    user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    user_agent.browser + " " + user_agent.version.to_s + " (" + user_agent.os + ")"
  end

  def find_city
    city = Geocoder.search(request.ip).first.city rescue nil
  end

  def find_login_history(account)
    login_history = account.login_histories.where(apparaat: find_browser,ip_address: request.ip,location: find_city).first
  end

  def login_history(account)
    Rails.logger.info { "parameters to add to history apparaat: #{find_browser},ip_address: #{request.ip},location: #{find_city}" }
    login_history = account.login_histories.create(apparaat: find_browser,ip_address: request.ip,location: find_city)
    Rails.logger.info { "last record #{account.login_histories.last.inspect}" }
    #login_history.update(verified: true)
  end

  def client_hash
    Base64.urlsafe_encode64( request.ip.to_s + request.env["HTTP_USER_AGENT"].to_s )[0..9]
  end

  def otp_enabled?
    account_by_email&.otp_enabled
  end

  def sms_otp_enabled?
    account_by_email&.sms_otp
  end

  def email_otp_enabled?
    account_by_email&.email_otp
  end

  def twofactor_enabled?
    account_by_email&.twofactor_enabled?
  end

  def twofactor_verify
    otp_verify if otp_enabled?
    sms_otp_verify if sms_otp_enabled?
    email_otp_verify if email_otp_enabled?
  end

  def sms_otp_verify
  end

  def email_otp_verify
  end

  def otp_verify
    return if Vault::TOTP.validate?(account_by_email.uid, params[:otp])

    set_flash_message! :alert, :wrong_otp_code
    redirect_to account_session_path
  rescue Vault::HTTPClientError => e
    redirect_to new_account_session_path, alert: "Vault error: #{e.errors.join}"
  end

  def account_by_email
    Account.kept.find_by_email(resource_params[:email])
  end
end
