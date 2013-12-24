module TextMining::Tools
  
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
        @ngrams << NGram.new(1, @options[:regex])
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
    
    protected
    #
    # Sequence finder
    #
    def seq_find
      
    end
  end
end