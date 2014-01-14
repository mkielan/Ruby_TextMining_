
module TextMining
  attr_reader :symbols
  attr_accessor :freq
  attr_accessor :symbol_card

  class NGram
    def initialize symbols
      @symbols = symbols
      @freq = 0
      @symbol_card = 0
    end

    def ==(y)
      return false if !y.is_a? NGram
      return false if self.symbols.length != y.symbols.length

      return self.symbols.compare y.symbols
    end

    def !=(y)
      not (self == y)
    end

    def to_s
      super + @symbols.to_s
    end
  end
end
