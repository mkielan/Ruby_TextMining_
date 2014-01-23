require 'set'

module TextMining

  #
  # N-grams manager to using many n-grams at the same time.
  #
  class NGramsManager
    attr_accessor :options
    attr_reader :ngrams_sets
    attr_reader :top_ngrams

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

      find_tops

      true
    end

    def vector_n_grams_for document
      # prepare to generate vector
      ngrams_vector = Array.new(@top_ngrams.length, 0)

      # generate vector
      @ngrams_sets.length.times { |i|
        tmp = NGrams.split_to_ngrams(document.tr_body, i + 1)

        #reduction absent in the top ngrams

        tmp.length.times { |k|
          index = @top_ngrams.find_index tmp[k]
          if !index.nil?
            ngrams_vector[index] += 1
          end
        }
      }

      ngrams_vector
    end

    private
    #
    # Find tops ngrams. With reduce ngrams when longer contain shorter
    # with similar probability.
    #
    def find_tops
      return if @ngrams_sets.length < 2

      @top_ngrams = []

      @ngrams_sets.length.times { |i|
        @top_ngrams.concat @ngrams_sets[i].top.ngrams
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