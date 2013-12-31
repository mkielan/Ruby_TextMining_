require 'set'

module TextMining

  #
  # N=grams manager to using many n-grams at the same time.
  #
  class NGramsManager
    attr_accessor :options
    attr_reader :ngrams_sets

    def initialize n = 4, options = {regex: / /}
      @ngrams_sets = []
      @options = options

      n = 4 if n < 1

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
    # Sequence find
    #
    # - <b>treshold</b> - mininmum support value for sequence, default value - 0.4
    def find_sequence treshold = 0.4
      bulding_sequences  []
      sequences = []
      merging_ngrams = Set.new
      top_ngrams = []
      
      #zebranie topowych ngramów
      (1..@ngrams_sets.length-1).each { |i|
        @ngrams_sets[i].reduce_containing!
        top_ngrams.concat @ngrams_sets[i].top
      }
      
      # przygotowanie startowego zbioru sekwencji 
      # oraz n-gramów, które dają się połączyć ze sobą
      top_ngrams.each { |ngram|
        top_ngrams.each { |ngram2|
          sequence = Sequence.new ngram
          if sequence.add ngram2
            merging_ngrams << ngram2
            bulding_sequences << sequence if sequence.support >= treshold
          end
        }
      }
      
      #wyszukiwanie sekwencji n-gramów
      while bulding_sequences.length == 0
        tmp_bulding_sequences = []
        
        #próba doklejania wybranych (łączących się ze sobą) n-gramów do sekwencji
        bulding_sequences.each { |seq|
          added = false
          
          merging_ngrams.each { |ngram| 
            if seq.add ngram[:symbol], ngram[:freq]
              added = true
              break
            end
          }
          
          if added
            #dodawany jeśli support ma conajmniej wartość progową
            sequences << seq if seq.support >= treshold
          else
            tmp_bulding_sequences << seq
          end
        }
        
        bulding_sequences = tmp_bulding_sequences
      end
      
      sequences
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