
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
  end
end
