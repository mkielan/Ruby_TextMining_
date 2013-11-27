module TextMining::Tools
  class NGram
    attr_reader :dimension
    attr_reader :symbols
    attr_reader :freqs

    def initialize n
      @dimension = n
      @symbols = []
      @freqs = []
    end

    def add doc
      return if doc.nil?

      if doc.is_a? Array
        doc.each { |d|
          add d
        }
      else
        freq = Array.new(@symbols.length, 0)
        @freqs << freq

        #usunięcie przecinków

        doc.downcase! # zmniejszamy wszystkie znaki
        symbols = '' ##doc.split(@regex).each_cons(@n).to_a

        symbols.each { |s|
          index = find s

          if index.nil?
            @symbols << s
            @freqs.map! { |f| f << 0 }
            index = @symbols.length - 1
          end

          freq[index] += 1
        }
      end
    end

    #
    # Find element at symbols list.
    #
    def find element
      if element.is_a?(Array) && (element.length == @dimension)
        (0..(@symbols.length - 1)).each { |i|
          return i if (element.compare @symbols[i]) == true

          # można spróbować miary Levensteina
        }
      end

      nil
    end
  end
end