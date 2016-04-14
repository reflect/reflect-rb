require 'uri'
require 'json'
require 'httparty'
require 'reflect/version'

module Reflect
  class Client
    include HTTParty

    base_uri 'https://api.reflect.io'

    def initialize(token)
      @token = token
    end

    def get(path)
      self.class.get(URI.encode(path), options)
    end

    def post(path, content)
      self.class.post(URI.encode(path), options(body: dump(content)))
    end

    def put(path, content)
      self.class.put(URI.encode(path), options(body: dump(content)))
    end

    def delete(path)
      logger.debug { "[reflect] Sending DELETE #{URI.encode(path)}" }
      self.class.delete(URI.encode(path), options)
    end

    def patch(path, content, headers={})
      opts = options(body: dump(content))
      opts[:headers].merge!(headers) unless headers.empty?
      self.class.patch(path, opts)
    end

    private

    def options(opts={})
      defaults = {
        basic_auth: { username: '', password: @token },
        headers: {
          "User-Agent" => "Reflect Ruby API client v#{Reflect::VERSION}",
          "Content-Type" => "application/json"
        }
      }

      opts.merge(defaults)
    end

    def dump(obj)
      JSON.dump(obj)
    end

    def logger
      Reflect.logger
    end
  end
end
