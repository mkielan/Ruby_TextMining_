module TextMining

  #
  # N=grams manager to using many n-grams at the same time.
  #
  class NGramsManager
    attr_accessor :options
    attr_reader :ngrams

    def initialize n = 3, options = {regex: / /}
      @ngrams = []
      @options = options

      n = 3 if n < 1

      (1..n).each { |i|
        @ngrams << NGram.new(i, @options[:regex])
      }
    end

    #
    # Add document to each ngrams
    #
    def add doc
      @ngrams.each { |ngram|
        ngram.add doc
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
      return if @ngrams.length < 2

      (1..@ngrams.count - 1).each { |i|
        @ngrams[i].reduce_containing!(@ngrams[i + 1])
      }
    end
  end
end