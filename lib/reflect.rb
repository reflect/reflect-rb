$:.unshift(File.expand_path("../", __FILE__))

require 'openssl'
require 'base64'
require 'json'

require 'reflect/parameter'
require 'reflect/version'

module Reflect
  def self.generate_token(secret_key, parameters=[])
    data = parameters.map do |param|
      is_arr = param.value.is_a? Array

      val = if !is_arr then param.value.to_s else '' end
      vals = if is_arr then param.value.map(&:to_s).sort else [] end

      JSON.generate([param.field, param.op, val, vals])
    end

    hash_json(secret_key, data)
  end


  private
  def self.hash_json(secret_key, json_data)
    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.new(secret_key, digest)
      .update("V2\n")
      .update(json_data.sort.join("\n"))
      .digest

    "=2=#{Base64.encode64(hmac).strip}"
  end
end
