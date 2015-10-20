module Reflect
  class KeyList
    include Enumerable

    attr_reader :keys
    attr_reader :next

    def initialize(keys, continuation)
      @keys = keys || []
      @next = continuation
    end

    def each(&blk)
      keys.each(&blk)
    end

    def empty?
      keys.count < 1
    end
  end
end
