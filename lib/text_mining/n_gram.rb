
module TextMining
  attr_reader :symbols
  attr_reader :cardinalities  # cardinality of ngrams
  attr_reader :symbol_freqs
  attr_reader :symbol_card

  class NGram

    def initialize
      @symbols = []
      @cardinalities = []
      @symbol_freqs = []
      @symbol_card = []
    end
  end
end
