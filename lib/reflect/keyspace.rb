require 'time'
require 'reflect/field'

module Reflect
  class Keyspace
    attr_reader :client

    attr_accessor :name
    attr_accessor :slug
    attr_accessor :statistics_key
    attr_accessor :description
    attr_accessor :fields
    attr_accessor :status
    attr_accessor :created_at
    attr_accessor :updated_at

    def initialize(client, attrs={})
      @client = client

      # If we have fields, we'll need to populate them individually.
      fields = attrs.delete("fields")

      attrs['updated_at'] = Time.parse(attrs['updated_at']) if attrs['updated_at']
      attrs['created_at'] = Time.parse(attrs['created_at']) if attrs['created_at']

      attrs.each do |k, v|
        self.send("#{k}=".to_s, v)
      end

      if fields
        self.fields = fields.map { |f| Field.new(f) }
      end
    end

    def keys(continuation=nil)
      resp = client.get(keys_path(slug, continuation))

      if resp.response.code != "200"
        raise Reflect::RequestError, Reflect._format_error_message(resp)
      end

      json = JSON.parse(resp.body)

      if json["keys"].nil? || json["keys"].empty?
        nil
      else
        KeyList.new(json["keys"], json["next"])
      end
    end

    # Appends records to a tablet. If the tablet doesn't exist it will be
    # created. records can be either a single object or an array of objects. A
    # single object represents a single row.
    #
    # @param String key the key to create
    # @param Array|Hash records the records to create
    #
    def append(key, records)
      resp = client.put(path(slug, key), records)

      if resp.response.code != "202"
        raise Reflect::RequestError, Reflect._format_error_message(resp)
      end
    end

    # Replaces the existing records in a tablet with a net set of records.
    # records can be either a single object or an array of objects. A single
    # object represents a single row.
    # 
    # @param String key the key to create
    # @param Array|Hash records the records to create
    #
    def replace(key, records)
      resp = client.post(path(slug, key), records)

      if resp.response.code != "202"
        raise Reflect::RequestError, Reflect._format_error_message(resp)
      end
    end

    # Patches the existing records in a tablet with a net set of records. The
    # criteria parameter indicates which records to match existing records on.
    # In the Reflect API, if no existing records match the supplied records
    # then those records are dropped.
    #
    # @param String key the key to create
    # @param Array|Hash records the records to create
    # @param Array criteria an array of field names within a record to match
    #
    def patch(key, records, criteria)
      resp = client.patch(path(slug, key), records, "X-Criteria" => criteria.join(", "))

      if resp.response.code != "202"
        raise Reflect::RequestError, Reflect._format_error_message(resp)
      end
    end

    # Deletes a key within a keyspace.
    #
    # @param String key the key to delete
    #
    def delete(key)
      resp = client.delete(path(slug, key))

      if resp.response.code != "202"
        raise Reflect::RequestError, Reflect._format_error_message(resp)
      end
    end

    private 

    def path(slug, key)
      "/v1/keyspaces/#{slug}/tablets/#{key}"
    end

    def keys_path(slug, continuation=nil)
      base = "/v1/keyspaces/#{slug}/keys"
      base += "?next=#{continuation}" if continuation
      base
    end
  end
end
