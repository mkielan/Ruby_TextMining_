module TextMining
  class Ngrams
    attr_accessor :options
    attr_reader :unigram
    attr_reader :digram
    attr_reader :trigram

    #
    # target - do wygenerowania ngram-ów
    #
    def initialize target, options = {regex: / /}
      @options = options
      @target = target

      @unigram = ngrams(1)
      @digram = ngrams(2)
      @trigram = ngrams(3)
    end

    #
    # Return ngram for given number.
    #
    def ngrams(n)
      Ngram.new @target, n, @options[:regex]
    end
  end
end


