$:.unshift(File.expand_path("../", __FILE__))

require 'reflect/key_list'
require 'reflect/request_error'
require 'reflect/keyspace'
require 'reflect/field'
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
end
