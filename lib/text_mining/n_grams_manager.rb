require 'set'

module TextMining

  #
  # N-grams manager to using many n-grams at the same time.
  #
  class NGramsManager
    attr_accessor :options
    attr_reader :ngrams_sets
    attr_reader :sequences
    attr_accessor :auto_find_sequence

    def initialize n = 4, options = {regex: / /}
      @ngrams_sets = []
      @options = options
      @top_ngrams = []
      @auto_find_sequence = true

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

      find_sequences if @auto_find_sequence

      true
    end

    #
    # Sequence find
    #
    # - <b>treshold</b> - mininmum support value for sequence, default value - 0.4
    def find_sequences treshold = 0.4
      bulding_sequences = []
      sequences = []
      merging_ngrams = Set.new

      @top_ngrams = find_tops

      # przygotowanie startowego zbioru sekwencji 
      # oraz n-gramów, które dają się połączyć ze sobą
      @top_ngrams.each { |ngram|
        @top_ngrams.each { |ngram2|
          sequence = Sequence.new ngram
          if sequence.add ngram2
            merging_ngrams << ngram2
            bulding_sequences << sequence if sequence.support >= treshold
          end
        }
      }
      
      #wyszukiwanie sekwencji n-gramów
      while bulding_sequences.length > 0
        tmp_bulding_sequences = []
        
        #próba doklejania wybranych (łączących się ze sobą) n-gramów do sekwencji
        bulding_sequences.each { |seq|
          added = false
          
          merging_ngrams.each { |ngram| 
            if seq.add ngram
              added = true
              break
            end
          }
          
          if added
            tmp_bulding_sequences << seq
          else
            #dodawany jeśli support ma conajmniej wartość progową
            sequences << seq if seq.support >= treshold
          end
        }
        
        bulding_sequences = tmp_bulding_sequences
      end

      @sequences = sequences
    end

    #
    # Find sequences for input document.
    #
    def find_sequences_for document
      if document.is_a? Document
        tmp_ngrams = []

        (0..@ngrams_sets.length - 1).each { |i|
          tmp = NGrams.split_ngram(document.tr_body, i + 1)

          #reduction absent in the top ngrams
          i = 0
          while i < tmp.length - 1 do
            tmp.delete_at i if !@top_ngrams.include?(tmp[i])
          end

          tmp_ngrams << tmp
        }

        # search sequences for document
        found = []
        indexes_step = Array.new(@ngrams_sets.length - 1, 0)
        @sequences.each { |seq|
          seq.each_index { |el_index|
            el_variant = seq[el_index].length - 1

            # TODO lepsze dobierania ngramu z tmp, może po poprawnej weryfikacji ustalić możliwe kroki dla każdej z długości
            ngrams = tmp_ngrams[el_variant]
            step_index = indexes_step[el_variant]
            if seq[el_index] != ngrams[step_index]
              break
            end

            if el_index == seq.length - 1
              found << seq
            else #calculate next index step
              indexes_step = NGramsManager.calcualte_next_step el_variant, indexes_step, tmp_ngrams
            end
          }
        }

        return found
      else
        raise ArgumentError, 'Excepted Document Class Object'
      end
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

    def self.calcualte_next_step el_variant, indexes_step, tmp_ngrams
      @ngrams_sets.length.times { |i|
        if i == el_variant
          indexes_step[i] += 1
        else
          (indexes_step[i]..tmp_ngrams[i].length - 1).each {

          }
        end
      }
    end
  end
end