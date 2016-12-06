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
  end
end
