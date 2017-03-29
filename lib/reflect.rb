$:.unshift(File.expand_path("../", __FILE__))

require 'openssl'
require 'base64'

require 'reflect/parameter'

module Reflect
  def self.generate_token(secret_key, parameters=[])
    data = parameters.map do |param|
      is_arr = param.value.is_a? Array

      val = if !is_arr then param.value.to_s else '' end
      vals = if is_arr then param.value.map(&:to_s).sort else [] end

      JSON.generate([param.field, param.op, val, vals])
    end

    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.new(secret_key, digest)
      .update("V2\n")
      .update(data.sort.join("\n"))
      .digest

    "=2=#{Base64.encode64(hmac).strip}"
  end
end
