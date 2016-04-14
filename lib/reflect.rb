$:.unshift(File.expand_path("../", __FILE__))

require 'openssl'
require 'base64'

require 'reflect/parameter'
require 'reflect/request_error'
require 'reflect/client'

module Reflect
  def self._format_error_message(resp)
    "An error occured with the request. Status: #{resp.response.code} Error: #{_extract_error_message(resp)}"
  end

  def self._extract_error_message(resp)
    begin
      json = JSON.parse(resp.body)
      json["error"]
    rescue JSON::ParserError
      # TODO: Report this?
      ""
    end
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new("/dev/null")
  end

  def self.generate_token(secret_key, parameters=[])
    data = parameters.map(&:to_s).sort
    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.digest(digest, secret_key, data.join("\n"))
    Base64.encode64(hmac).strip
  end
end
