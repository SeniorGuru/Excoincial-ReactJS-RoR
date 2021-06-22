# frozen_string_literal: true

module UserApi
  module V1
    class Base < Grape::API
      PREFIX = '/users/api'
      API_VERSION = 'v1'

      version API_VERSION, using: :path

      cascade false

      format         :json
      content_type   :json, 'application/json'
      default_format :json

      logger Rails.logger.dup
      logger.formatter = GrapeLogging::Formatters::Rails.new
      use GrapeLogging::Middleware::RequestLogger,
          logger:    logger,
          log_level: :info,
          include:   [GrapeLogging::Loggers::Response.new,
                      GrapeLogging::Loggers::FilterParameters.new,
                      GrapeLogging::Loggers::ClientEnv.new,
                      GrapeLogging::Loggers::RequestHeaders.new]

      helpers V1::Helpers

      do_not_route_options!

      rescue_from(ActiveRecord::RecordNotFound) { |_e| error!('Record is not found', 404) }
      # Known Vault Error from Vault::TOTP.with_human_error
      rescue_from(Vault::TOTP::Error) do |error|
        error!(error.message, 422)
      end
      # Unknown Vault error
      rescue_from(Vault::VaultError) do |error|
        Rails.logger.error "#{error.class}: #{error.message}"
        error!('Something wrong with 2FA', 422)
      end

      rescue_from(Twilio::REST::RestError) do |error|
        Rails.logger.error "Twilio Client Error: #{error.message}"
        error!('Something wrong with Twilio Client', 500)
      end

      rescue_from(Grape::Exceptions::ValidationErrors) do |error|
        error!(error.message, 400)
      end

      rescue_from(:all) do |error|
        Rails.logger.error "#{error.class}: #{error.message}"
        error!('Something went wrong', 500)
      end

      use UserApi::V1::CORS::Middleware

      mount UserApi::V1::Accounts
      mount UserApi::V1::Articles
      mount UserApi::V1::Profiles
      mount UserApi::V1::Security
      mount UserApi::V1::Documents
      mount UserApi::V1::Phones
      mount UserApi::V1::Sessions
      mount UserApi::V1::Labels
      mount UserApi::V1::APIKeys

      add_swagger_documentation base_path: PREFIX,
                                info: {
                                  name: 'Excoincial Barong',
                                  title: 'Barong',
                                  description: 'API for barong OAuth server ',
                                  contact_name:  'Oleksandr Papevis CTO of Excoincial Exchange, Head of Support Africunia Bank',
                                  contact_email: 'aleksander@africunia.org',
                                  contact_url:   'https://excoincial.com',
                                  licence:       'MIT',
                                  license_url:   'https://github.com/africunia/excoincial-api/blob/master/LICENSE.md'
                                },
                                security_definitions: {
                                  "BearerToken": {
                                    description: 'Bearer Token authentication',
                                    type: 'apiKey',
                                    name: 'Authorization',
                                    in: 'header'
                                  }
#                                  Bearer: {
#                                    type: "apiKey",
#                                    name: "JWT",
#                                    in: "header"
#                                  }
                                },
                                models: [
                                  Entities::Label,
                                  Entities::APIKey,
                                  Entities::AccountWithProfile,
                                  Entities::Profile
                                ],
                                api_version: API_VERSION,
                                doc_version: Barong::VERSION,
#                                hide_format: true,
#                                hide_documentation_path: true,
                                mount_path: '/swagger_doc'

      route :any, '*path' do
        raise StandardError, 'Unable to find endpoint'
      end
    end
  end
end
