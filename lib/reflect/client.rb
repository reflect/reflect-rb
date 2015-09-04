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

    def keyspace(slug)
      res = get("/v1/keyspaces/#{slug}")

      if res.response.code == "200"
        Keyspace.new(self, JSON.parse(res.body))
      else
        # TODO: What happens if we failed to look this up or whatever?
        nil
      end
    end

    def get(path)
      self.class.get(path, options)
    end

    def post(path, content)
      self.class.post(path, options(body: dump(content)))
    end

    def put(path, content)
      self.class.put(path, options(body: dump(content)))
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
  end
end
