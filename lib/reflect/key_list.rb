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
  end
end
