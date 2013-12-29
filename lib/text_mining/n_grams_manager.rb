module TextMining

  #
  # N=grams manager to using many n-grams at the same time.
  #
  class NGramsManager
    attr_accessor :options
    attr_reader :ngrams_sets

    def initialize n = 3, options = {regex: / /}
      @ngrams_sets = []
      @options = options

      n = 3 if n < 1

      (1..n).each { |i|
        @ngrams_sets << NGrams.new(i, @options[:regex])
      }
    end

    #
    # Add document to each ngrams
    #
    def add doc
      @ngrams_sets.each { |ngrams|
        ngrams.add doc
      }
    end

    #
    # Sequence finder
    #
    def seq_find

    end

    #
    # Reduce ngrams when longer contain shorter 
    # with similar probability.
    def reduce #dobre miejsce na MapReduce
      return if @ngrams_sets.length < 2

      (1..@ngrams_sets.count - 1).each { |i|
        @ngrams_sets[i].reduce_containing!(@ngrams_sets[i + 1])
      }
    end
  end
end