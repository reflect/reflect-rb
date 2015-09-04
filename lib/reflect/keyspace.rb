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

    # Appends records to a tablet. If the tablet doesn't exist it will be
    # created.
    #
    # @param String key the key to create
    # @param Array|Hash records the records to create
    #
    def append(key, records)
      client.put("/v1/keyspaces/"+self.slug+"/tablets/"+key, records)
    end

    # Replaces the existing records in a tablet with a net set of records.
    #
    # @param String key the key to create
    # @param Array|Hash records the records to create
    #
    def replace(key, records)
      client.put("/v1/keyspaces/"+self.slug+"/tablets/"+key, records)
    end
  end
end
