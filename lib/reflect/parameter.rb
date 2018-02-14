module Reflect
  class Parameter
    attr_reader :field
    attr_reader :op
    attr_accessor :value

    def initialize(field, op, value=nil)
      @field = field
      @op = op
      @value = value
    end

    def to_json(*a)
      h = { field: field, op: op }
      h[value.is_a?(Array) ? 'any' : 'value'] = value

      h.to_json(*a)
    end
  end
end
