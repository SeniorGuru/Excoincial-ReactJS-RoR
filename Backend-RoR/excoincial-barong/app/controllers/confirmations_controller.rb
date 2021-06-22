# frozen_string_literal: true

require 'uri'

class ConfirmationsController < Devise::ConfirmationsController
  # POST /resource/confirmation
  def create
    account = Account.find_by_email resource_params[:email]
    if account
      account.current_sign_in_ip = request.remote_ip
      account.save
    end
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  private

  def after_confirmation_path_for(resource_name, resource)
    return super if params[:redirect_uri].blank? || ENV['DOMAIN_NAME'].blank?
    domain = URI(params[:redirect_uri]).host
    root_domain = PublicSuffix.parse(domain).domain
    return params[:redirect_uri] if ENV['DOMAIN_NAME'] == root_domain

    super
  end
end
