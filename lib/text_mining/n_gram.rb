module TextMining::Tools
  class NGram
    attr_reader :dimension #rozmiar
    attr_reader :symbols #symbole
    attr_reader :cardinalities #częstość
    attr_reader :symbol_freqs #częstości znaków

    def initialize n, regex = / /
      @dimension = n
      @symbols = []
      @symbol_freqs = []
      @symbol_card = []
      @cardinalities = []
      @regex = regex
    end

    #
    # Add single document or collection.
    #
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

    # Return symbols and freqs with order the most frequent to least
    #
    # top with freqs[first..to]
    # value range freqs[x1, x2]
    def freqs
      freqs = Freqs.new

      (0..@symbols.length - 1).each { |i|
        freqs << Hash[:symbol, @symbols[i], :freq, @symbol_freqs[i]]
      }

      freqs.sort! { |a, b| b[:freq] <=> a[:freq] }
    end

    #
    # Return most frequent symbol with value of freq
    def top
      count = @symbols.length

      if count > 0
        part_width = (count.to_f / 3.0).to_int
        return freqs[0..part_width]
      end

      nil
    end

    protected
    #
    # Add single document.
    #
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

    #
    # Calculate freqs for current state of symbols
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
          begin
            return i if element.cmp_levenshtein(@symbols[i]) == true
          rescue
            return i if element.compare(@symbols[i]) == true
          end
          # można spróbować miary Levensteina
        }
      end

      nil
    end
  end
end