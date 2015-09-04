module Reflect
  class Field
    attr_accessor :name
    attr_accessor :column_type
    attr_accessor :type
    attr_accessor :description
    attr_accessor :fields
    attr_accessor :created_at
    attr_accessor :updated_at

    def initialize(client, attrs={})
      @client = client

      attrs.each do |k, v|
        self.send("#{k}=".to_s, v)
      end
    end
  end
end
