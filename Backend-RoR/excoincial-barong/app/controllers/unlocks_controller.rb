# frozen_string_literal: true

require 'uri'

class UnlocksController < Devise::UnlocksController
  def create
    account = Account.find_by_email resource_params[:email]
    if account.state == "banned"
      yield resource if block_given?
      Rails.logger.debug { resource.inspect }
      form_params = Hash[:email, account.email]
      form_params[:name] = account.profile.first_name if account.profile.present?
      form_params[:phone] = account.phones.first.number if account.phones.present?
      form_params[:subject] = "re-activate my account"
      respond_with(resource, location: '/#contact?' + form_params.to_query)
    else
      self.resource = resource_class.send_unlock_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        respond_with({}, location: after_resending_unlock_instructions_path_for(resource_name))
      else
        respond_with(resource)
      end
    end
  end

  private

  def after_sending_unlock_instructions_path_for(resource)
    super(resource)
  end

  def after_resending_unlock_instructions_path_for(resource)
    after_sending_unlock_instructions_path_for(resource)
  end

end