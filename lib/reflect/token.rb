require 'json'
require 'jwe'

module Reflect

  class ProjectTokenBuilder
    VIEW_IDENTIFIERS_CLAIM_NAME = 'http://reflect.io/s/v3/vid'
    PARAMETERS_CLAIM_NAME = 'http://reflect.io/s/v3/p'
    ATTRIBUTES_CLAIM_NAME = 'http://reflect.io/s/v3/a'

    def initialize(access_key)
      @access_key = access_key

      @expiration = nil
      @view_identifiers = []
      @parameters = []
      @attributes = {}
    end

    def expiration(expiration)
      @expiration = expiration.to_i
      self
    end

    def add_view_identifier(id)
      @view_identifiers << id
      self
    end

    def add_parameter(parameter)
      @parameters << parameter
      self
    end

    def set_attribute(name, value)
      @attributes[name] = value
      self
    end

    def build(secret_key)
      key_bytes = secret_key.scan(/[0-9a-f]{4}/).map { |x| x.to_i(16) }
      key = key_bytes.pack('n*')

      now = Time.now.to_i

      payload = {
        :iat => now,
        :nbf => now,
      }

      payload[:exp] = @expiration unless @expiration.nil?

      payload[VIEW_IDENTIFIERS_CLAIM_NAME] = @view_identifiers unless @view_identifiers.empty?
      payload[PARAMETERS_CLAIM_NAME] = @parameters unless @parameters.empty?
      payload[ATTRIBUTES_CLAIM_NAME] = @attributes unless @attributes.empty?

      # The default JWE encryption mechanism doesn't let us specify the
      # additional header fields we need, so let's do it by hand.
      header = {
        alg: 'dir',
        enc: 'A128GCM',
        zip: 'DEF',
        cty: 'JWT',
        kid: @access_key,
      }

      zipped_payload = JWE::Zip.for(header[:zip]).new.send(:compress, JSON.generate(payload))
      json_header = JSON.generate(header)

      cipher = JWE::Enc.for(header[:enc]).new
      cipher.cek = key

      bin = cipher.encrypt(zipped_payload, JWE::Base64.jwe_encode(json_header))
      encrypted_cek = JWE::Alg.for(header[:alg]).new(key).encrypt(cipher.cek)

      JWE::Serialization::Compact.encode(json_header, encrypted_cek, cipher.iv, bin, cipher.tag)
    end
  end

end
