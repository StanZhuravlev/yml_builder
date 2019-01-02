module YmlBuilder # :nodoc:
  class Stats
    attr_reader :stats


    def initialize
      init_class
    end


    def init_class
      @stats              = Hash.new
      @stats[:categories] = 0
      @stats[:total]      = 0
      @stats[:available]  = 0
      @stats[:price]      = 0
    end


    def add(key, value)
      @stats[key] += value
    end

  end
end