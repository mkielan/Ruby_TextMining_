module TextMining::Tools
  class NGram
    attr_reader :dimension
    attr_reader :symbols
    attr_reader :cardinalities
    attr_reader :symbol_freqs

    def initialize n, regex = / /
      @dimension = n
      @symbols = []
      @symbol_freqs = []
      @symbol_card = []
      @cardinalities = []
      @regex = regex
    end

    def add doc
      return if doc.nil?

      if doc.is_a? Array
        doc.each { |d|
          add d
        }
      else
        cardinality = Array.new(@symbols.length, 0)
        @cardinalities << cardinality

        if doc.is_a? TextMining::Document
          doc.parts.each { |p|
            single_add p, cardinality
          }
        else
          single_add doc, cardinality
        end

        calculate_freqs cardinality
      end
    end

    protected
    def single_add doc, cardinality
      doc.downcase! # zmniejszamy wszystkie znaki
      symbols = doc.gsub(/[\s]+/, ' ').split(@regex).each_cons(@dimension).to_a

      symbols.each { |s|
        #next if s.match /[\s]+/
        index = find s

        if index.nil?
          @symbols << s
          @cardinalities.map! { |f| f << 0 }
          index = @symbols.length - 1
        end

        cardinality[index] += 1
      }
    end

    def calculate_freqs cardinality

      diff = cardinality.length - @symbol_card.length
      (1..diff).each { @symbol_card << 0 }

      #@symbol_freqs = Array.new @symbols.length, 0

      # for each symbols
      (0..@symbols.length - 1).each { |s|
        @symbol_card[s] += 1 if cardinality[s] > 0
      }

      @symbol_freqs = @symbol_card.map { |f| f.to_f / @cardinalities.length.to_f }
    end

    #
    # Find element at symbols list.
    #
    public
    def find element
      if element.is_a?(Array) && (element.length == @dimension)
        (0..(@symbols.length - 1)).each { |i|
          return i if element.compare(@symbols[i]) == true

          # można spróbować miary Levensteina
        }
      end

      nil
    end
  end
end