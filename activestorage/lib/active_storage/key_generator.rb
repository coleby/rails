# frozen_string_literal: true

module ActiveStorage
  class KeyGenerator
    def initialize(blob)
      @blob = blob
      @key_format = blob.key_format || ":hash"
    end

    def generate
      key_format.scan(/:\w+/).reduce(key_format) do |interpolating, token|
        converted = convert_token(token)
        interpolating.sub(token, converted)
      end
    end

    private
      attr_reader :blob, :key_format

      def convert_token(token)
        case token
        when ":hash"
          blob.class.generate_unique_secure_token
        when ":filename"
          blob.filename.base
        when ":extension"
          blob.filename.extension_without_delimiter
        else
          raise StandardError, "Unsupported token #{token}"
        end
      end
  end
end
