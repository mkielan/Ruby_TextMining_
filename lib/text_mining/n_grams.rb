module TextMining
  
  #
  # N-grams with one dimension. 
  #
  class NGrams
    attr_reader :dimension      # length of n-grams
    attr_reader :symbols        # collection of ngrams
    attr_reader :cardinalities  # cardinality of ngrams
    attr_reader :symbol_freqs   # freqs of ngrams
    attr_reader :documents_count

    def initialize n, regex = / /
      @dimension = n
      @symbols = []
      @symbol_freqs = []
      @symbol_card = []
      @cardinalities = []
      @regex = regex
      @documents_count = 0
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

    def self.split_ngram doc, regex, dimension
      doc.gsub(/[\s]+/, ' ').split(regex).each_cons(dimension).to_a
    end

    protected
    #
    # Add single document.
    #
    def single_add doc, cardinality
      doc.downcase! # zmniejszamy wszystkie znaki
      @documents_count += 1
      symbols = NGrams.split_ngram doc, @regex, @dimension

      symbols.each { |s|
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
    #
    def calculate_freqs cardinality
      diff = cardinality.length - @symbol_card.length

      (1..diff).each { @symbol_card << 0 }

      # for each symbols
      (0..@symbols.length - 1).each { |s|
        @symbol_card[s] += 1 if cardinality[s] > 0
      }

      @symbol_freqs = @symbol_card.map { |f| f.to_f / @documents_count.to_f }
    end

    def delete_at i
      @symbols.delete_at i
      @symbol_card.delete_at i
      @symbol_freqs.delete_at i
      @cardinalities.delete_at i
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
        }
      end

      nil
    end

    #tu przydałby się MapReduce
    # Reduce symbols containing in input Ngram
    #
    def reduce_containing! ngrams, deflection = 0.01
      if ngrams.is_a? NGrams
        if ngrams.dimension >= self.dimension
          i = 0

          #sprawdzam, czy któryś z symboli zawiera się w którymś z drugiego ngramu
          while i < (@symbols.length - 1) and @symbols.length == 0 do
            #sprawdzenie dla symboli z drugiego n-gramu
            ngrams.symbols.length.times { |j|
              if ngrams.symbols[j].order_containing(@symbols[i])

                if ngrams.symbol_freqs[j] >= @symbol_freqs[i] - deflection \
                  and ngrams.symbol_freqs[j] <= @symbol_freqs[i] + deflection
                  puts "delete #{@symbols[i]} support(#{@symbol_freqs[i]}), because in #{ngrams.symbols[j]} support(#{ngrams.symbol_freqs[j]}"

                  delete_at i
                  break if @symbols.length == 0
                  next
                end
              end
            }
=begin
            ngrams.symbols.each { |symbol|
              if symbol.order_containing(@symbols[i])
                index = ngrams.find symbol

                if ngrams.symbol_freqs[index] >= @symbol_freqs[i] - deflection \
                  and ngrams.symbol_freqs[index] <= @symbol_freqs[i] + deflection

                  delete_at i
                  next
                end
              end
            }
=end
            i += 1
          end
        end
      else
        'Excepted NGram class object'
      end

      nil
    end
  end
end