# encoding: UTF-8
# frozen_string_literal: true

module APIv2
  module Auth
    class Middleware < Grape::Middleware::Base
      def before
        return unless auth_by_jwt?

        env['api_v2.authentic_member_email'],env['api_v2.authentic_scopes'] = \
          JWTAuthenticator.new(headers['Authorization']).authenticate!(return: [:email,:scopes])
        #puts "env['api_v2.authentic_scopes'] #{env['api_v2.authentic_scopes'].inspect}"
      end
    private

      def auth_by_jwt?
        return true unless !auth_by_bearer?
        return unless headers.key?('Jwt')
        headers['Authorization'] = 'Bearer ' + headers['Jwt'].to_s
        auth_by_bearer?
      end

      def auth_by_bearer?
        headers.key?('Authorization')
      end

      def request
        @request ||= Grape::Request.new(env)
      end

      def params
        request.params
      end

      def headers
        request.headers
      end
    end
  end
end
