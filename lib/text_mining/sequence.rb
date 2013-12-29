module TextMining
  class Sequence
    attr_reader :elements
    attr_reader :support
    
    def initialize
      @elements = []
      @supports = []
      @support = 0
    end
    
    def add_to_front element, support
      @elements.unshift element
      @supports.unshift support
    end
    
    def add_to_end element, support
      @elements << element
      @supports << support
    end
    
    def contain other
      #TODO
      false
    end
    
    def to_s
      @elements.to_s
    end
    
    private
    def support_recount
      @support = @supports.sum.to_f / @supports.length.to_f
    end
  end
end