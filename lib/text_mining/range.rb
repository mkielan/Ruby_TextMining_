
module TextMining

  class Range
    attr_accessor :first
    attr_accessor :last

    def initialize first, last
      @first = first
      @last = last
    end

    def to_s
      @first.to_s + '-' + @last.to_s
    end
  end
end
