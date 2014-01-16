require 'set'

module TextMining

  #
  # N-grams manager to using many n-grams at the same time.
  #
  class NGramsManager
    attr_accessor :options
    attr_reader :ngrams_sets

    def initialize n = 4, options = { regex: / / }
      @ngrams_sets = []
      @options = options
      @top_ngrams = []

      n = 4 if n < 1

      (1..n).each { |i|
        @ngrams_sets << NGrams.new(i, @options[:regex])
      }
    end

    #
    # Add document to each n-grams
    #
    def add doc
      return false if doc.nil?

      @ngrams_sets.each { |ngrams|
        ngrams.add doc
      }
      true
    end

    def vector_n_grams_for document
      # prepare to generate vector
      ngrams_vector = []

      # generate vector
      @ngrams_sets.length.times { |i|
        tmp = NGrams.split_to_ngrams(document.tr_body, i + 1)
        ngrams_vector << Array.new(@ngrams_sets[i].length, 0)

        #reduction absent in the top ngrams
        k = 0
        while k < tmp.length - 1 do
          if NGramsManager.include_ngrams? @top_ngrams, tmp[k]
            k += 1
          else
            tmp.delete_at k
          end
        end

        tmp.each { |ngram|
          index = @ngrams_sets.find_index ngram
          ngrams_vector[index] += 1
        }
      }

      vector = []
      ngrams_vector.each { |e| vector.concat(e) }
      vector
    end

    private
    #
    # Find tops ngrams. With reduce ngrams when longer contain shorter
    # with similar probability.
    #
    def find_tops
      return if @ngrams_sets.length < 2

      @top_ngrams = []
      temp = []

      @ngrams_sets.length.times { |i| temp << @ngrams_sets[i].dup }

      (1..temp.length - 2).each { |i|
        temp[i].reduce_containing!(temp[i + 1])

        @top_ngrams.concat @ngrams_sets[i]
      }

      @top_ngrams
    end

    def ngrams_are sets_ngrams
      if sets_ngrams.is_a? Array
        sum = 0

        sets_ngrams.each { |ngrams| sum += ngrams.length }

        return sum > 0
      else
        raise 'Array object excepted'
      end
    end

    def self.include_ngrams? array_ngrams, ngram
      array_ngrams.each { |a|
        return true if a.symbols.compare ngram.symbols
      }

      false
    end
  end
end