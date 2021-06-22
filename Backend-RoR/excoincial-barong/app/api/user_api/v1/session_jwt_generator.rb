# frozen_string_literal: true

require 'barong/security/access_token'

module UserApi
  module V1
    class SessionJWTGenerator
      ALGORITHM = 'RS256'

      def initialize(jwt_token:, kid:)
        @kid = kid
        @jwt_token = jwt_token.split("\n").join("")
        @api_key = APIKey.active.find_by!(uid: kid)
      end

      def verify_payload
        payload, = decode_payload
        Rails.logger.debug { "payload first element fetched? : " + payload.inspect }
        payload.present?
        rescue TypeError => e
          result = nil
          data = []
          data[-1] += "possibly JWT decode returned TypeError"
          data[-1] += "\n"
          data[-1] += e.message
          data[-1] += "\n"
          data[-1] += e.backtrace
          AdminExceptionReportMailer.error(
            @api_key&.account,
            data.join('')
          ).deliver_now
      end

      def generate_session_jwt
        account = @api_key.account
        payload = {
          iat: Time.current.to_i,
          exp: @api_key.expires_in.seconds.from_now.to_i,
          sub: 'session',
          iss: 'barong',
          aud: @api_key.scopes,
          jti: SecureRandom.hex(12).upcase,
          uid:   account.uid,
          email: account.email,
          role:  account.role,
          level: account.level,
          state: account.state,
          api_kid: @api_key.uid
        }

        JWT.encode(payload, Barong::Security.private_key, ALGORITHM)
      end

    private

      def decode_payload
        public_key = OpenSSL::PKey.read(Base64.urlsafe_decode64(@api_key.public_key))

        data = []
        data << "!!TODO!! remove debug implemented in revision https://redmine.africunia.com/projects/excoincial-peatio-shared-environment-github/repository/revisions/029d836887cab0ced09d6246b6ee5b2595061693 public_key " + public_key.inspect
#=begin
        data[-1] += "\n"
        data[-1] += "@api_key look.public_key " + @api_key.inspect
        data[-1] += "\n"
        data[-1] += "@api_key.public_key " + @api_key.public_key.inspect
        data[-1] += "\n"
        data[-1] += "Base64.urlsafe_decode64(@api_key.public_key) " + Base64.urlsafe_decode64(@api_key.public_key).inspect
        data[-1] += "\n"
        data[-1] += "\n"
        Rails.logger.debug { data[-1] }

        data << "public_key.private?" + public_key.private?.to_s
        data[-1] += "\n"
        data[-1] += "\n"
        Rails.logger.debug { data[-1] }
#=end
        return {} if public_key.private?

#=begin
        data << "evaluating JWT.decode(@jwt_token,public_key,true,APIKey::JWT_OPTIONS) with the following parameters"
        data[-1] += "\n"
        data[-1] += "@jwt_token instance of " + @jwt_token.class.inspect + " and equals:" + @jwt_token.inspect
        data[-1] += "\n\n"
        data[-1] += "public_key instance of " + public_key.class.inspect + " and equals:" + public_key.inspect
        data[-1] += "\n"
        data[-1] += "true is true\t"
        data[-1] += "APIKey::JWT_OPTIONS " + APIKey::JWT_OPTIONS.inspect
        data[-1] += "\n"
        Rails.logger.debug { data[-1] }
        data << "\n"
        begin
          data[-1] += "JWT decoded " + JWT.decode(@jwt_token,public_key,true,APIKey::JWT_OPTIONS).inspect
        rescue TypeError => e
          data[-1] += "JWT decode failed due to TypeError"
          data[-1] += "\n"
          data[-1] += e.message
          data[-1] += "\n"
          data[-1] += e.backtrace
        rescue => e
          data[-1] += "JWT decode failed"
          data[-1] += "\n"
          data[-1] += e.message
          data[-1] += "\n"
          begin
            data[-1] += e.backtrace
          rescue
            data[-1] += "failed to backtrace"
          end
          data[-1] += "\n"
        end
#=end
        begin
          result = \
          JWT.decode(@jwt_token,
                     public_key,
                     true,
                     APIKey::JWT_OPTIONS)
=begin
          data[-1] += "JWT decoded " + result.inspect
          Rails.logger.debug { data[-1] }
          AdminExceptionReportMailer.info(
            @api_key&.account,
            data.join('')
          ).deliver_now
=end
        rescue TypeError => e
          result = nil
          data[-1] += "JWT decode returned nil due to TypeError"
          data[-1] += "\n"
          data[-1] += e.message
          data[-1] += "\n"
          data[-1] += e.backtrace
          Rails.logger.debug { data[-1] }
          AdminExceptionReportMailer.error(
            @api_key&.account,
            data.join('')
          ).deliver_now
        rescue => e
          result = nil
          data[-1] += "JWT decode returned nil "
          data[-1] += "\n"
          data[-1] += e.message
          data[-1] += "\n"
          begin
            data[-1] += e.backtrace
          rescue
            data[-1] += "failed to backtrace"
          end
          Rails.logger.debug { data[-1] }
          AdminExceptionReportMailer.error(
            @api_key&.account,
            data.join('')
          ).deliver_now
        end
        return result
      end
    end
  end
end
