module TextMining
  
  #
  # N-grams with one dimension. 
  #
  class NGrams < Array
    attr_reader :dimension      # length of n-grams
    attr_reader :documents_count

    def initialize n, regex = / /
      @dimension = n
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
        cardinality = Array.new(self.length, 0)

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
      ret = Freqs.new

      (0..length - 1).each { |i|
        ret << Hash[:symbol, self[i].symbols, :freq, self[i].freq]
      }

      ret.sort! { |a, b| b[:freq] <=> a[:freq] }
    end

    #
    # Return most frequent symbol with value of freq
    #
    def top
      count = self.length

      if count > 0
        part_width = (count.to_f / 3.0).to_int
        return freqs[0..part_width]
      end

      nil
    end

    def self.split_ngram doc, dimension, regex = / /
      doc.downcase.gsub(/[\s]+/, ' ').split(regex).each_cons(dimension).to_a
    end

    def self.split_to_ngrams doc, dimension, regex = / /
      tmp = self.split_ngram doc, dimension, regex

      ret = []

      tmp.length.times { |i| ret << NGram.new(tmp[i]) }

      ret
    end

    protected
    #
    # Add single document.
    #
    def single_add doc, cardinality
      @documents_count += 1

      NGrams.split_ngram(doc, @dimension, @regex).each { |s|
        index = find s

        if index.nil?
          self << NGram.new(s)

          cardinality << 1
        else
          cardinality[index] += 1
        end
      }
    end

    #
    # Calculate freqs for current state of symbols
    #
    def calculate_freqs cardinality
      # for each symbols
      (0..self.length - 1).each { |s|
        self[s].symbol_card += 1 if cardinality[s] > 0
      }

      self.map { |f| f.freq = f.symbol_card.to_f / @documents_count.to_f }
    end

    #
    # Find element at symbols list.
    #
    public
    def find element
      if element.is_a?(Array) && (element.length == @dimension) && self.length > 0
        (0..(self.length - 1)).each { |i|
          begin
            return i if element.cmp_levenshtein(self[i].symbols) == true
          rescue
            return i if element.compare(self[i].symbols) == true
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
          while i < (self.length - 1) and self.length == 0 do
            #sprawdzenie dla symboli z drugiego n-gramu
            ngrams.length.times { |j|
              if self[i].symbols.order_containing(self[i].symbols)

                if ngrams[j].freq >= self[i].freq - deflection \
                  and ngrams[j].freq <= self[i].freq + deflection
                  puts "delete #{self[i].symbols} support(#{self[i].freq}), because in #{ngrams[j].symbols} support(#{ngrams[j].symbol_freqs}"

                  delete_at i
                  break if self.length == 0
                  next
                end
              end
            }

            i += 1
          end
        end
      else
        raise 'Excepted NGram class object'
      end

      nil
    end
  end
end