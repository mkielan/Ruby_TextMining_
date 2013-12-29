module TextMining
  class Sequence
    attr_reader :elements
    
    def initialize
      @elements = []
    end
    
    def add_to_front element
      @elements.unshift element
    end
    
    def add_to_end element
      @elements << element
    end
    
    def to_s
      @elements.to_s
    end
    
  end
end