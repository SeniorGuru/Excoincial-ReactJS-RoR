module Arke
  # This class stores configuration for Arke application
  module Configuration
    PropertyNotSetError = Class.new(StandardError)

    class << self
      # Inits configuration holder
      def define
        @config ||= OpenStruct.new
        yield(@config)
      end

      # Returns requested key
      # * returns +nil+ if key is not set
      def get(key)
        @config ||= OpenStruct.new
        @config[key]
      end

      # Returns requested key
      # * raises PropertyNotSetError if key is not set
      def require!(key)
        Arke::Log.debug "configuration initialized with key " + key.to_s +
          "resolved to " + get(key).inspect
        get(key) || (raise PropertyNotSetError.new)
      end
    end
  end
end
