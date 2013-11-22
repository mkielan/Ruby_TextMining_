
module TextMining
  class Ngrams
    attr_accessor :options

    #
    # target - do wygenerowania ngram-ów
    #
    def initialize target, options = { regex: / / }
      @options = options
      @target = target
    end

    #
    # Return ngram for given number.
    #
    def ngrams(n)
      Ngram.new @target, n, @options[:regex]
    end

    def unigrams
      ngrams 1
    end

    def bigrams
      ngrams 2
    end

    def trigrams
      ngrams 3
    end
  end
end


