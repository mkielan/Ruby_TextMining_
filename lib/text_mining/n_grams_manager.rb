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

    def initialize n = 4, options = { regex: / / }
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
      @top_ngrams.length.times { |ngram|
        (ngram + 1..@top_ngrams.length - 1).each { |ngram2|
          if @top_ngrams[ngram] != @top_ngrams[ngram2]
            sequence = Sequence.new @top_ngrams[ngram]
            if sequence.expanded_support(@top_ngrams[ngram2]) >= treshold\
            and sequence.add @top_ngrams[ngram2]

              merging_ngrams << @top_ngrams[ngram2]
              bulding_sequences << sequence #if sequence.support >= treshold
            end
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
            seq_clone = seq.clone
            if seq_clone.expanded_support(ngram) >= treshold and seq_clone.add ngram
              added = true

              tmp_bulding_sequences << seq_clone

              break
            end
          }
          
          if added
            #tmp_bulding_sequences << seq #if seq.support >= treshold
          else
            #dodawany jeśli support ma conajmniej wartość progową
            sequences << seq #if seq.support >= treshold
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
        tmp_sets_ngrams = []

        (1..@ngrams_sets.length - 1).each { |i|
          tmp = NGrams.split_to_ngrams(document.tr_body, i + 1)

          #reduction absent in the top ngrams
          k = 0
          while k < tmp.length - 1 do
            if NGramsManager.include_ngrams? @top_ngrams, tmp[k]
              k += 1
            else
              tmp.delete_at k
            end
          end

          tmp_sets_ngrams << tmp
        }

        # search sequences for document,
        # because we deleted items not in top,
        # so we can't use one level n-gram.
        found = []
        uni_idx = 0 # index of unigram
        unigrams = NGrams.split_to_ngrams(document.tr_body, 1) #tmp_sets_ngrams[0]

        range = 0..tmp_sets_ngrams.length - 1
        while ngrams_are(tmp_sets_ngrams[1, tmp_sets_ngrams.length - 1]) and uni_idx < tmp_sets_ngrams[0].length do
          sequence = Sequence.new
          sequence_build_finish = false

          while !sequence_build_finish and uni_idx < unigrams.length do
            tmp = nil

            range.each { |set_id|
              next if tmp_sets_ngrams[set_id].length == 0

              if sequence.length == 0
                if tmp_sets_ngrams[set_id][0].symbols[0] == unigrams[uni_idx].symbols[0]
                  tmp = tmp_sets_ngrams[set_id][0]
                  tmp_sets_ngrams[set_id].delete_at 0
                end
              else
                if sequence.ends_at tmp_sets_ngrams[set_id][0]
                  tmp = tmp_sets_ngrams[set_id][0]
                  tmp_sets_ngrams[set_id].delete_at 0
                end
              end
            }

            # usunięcie w zbiorach takich n-gamów, które zawierają się w sekwencji
            # (do pierwszego niezawierającego się)
            if sequence.length > 0
              range.each { |set_id|
                while sequence.unique_elements.order_containing tmp_sets_ngrams[set_id][0].symbols
                  tmp_sets_ngrams[set_id].delete_at 0
                end
                #while tmp_sets_ngrams[set_id] != nil and sequence.ends_at tmp_sets_ngrams[set_id][0] do
                #  tmp_sets_ngrams[set_id].delete_at 0
                #end
              }
            end

            if !tmp.nil?
              sequence.add tmp
            else
              if sequence.length == 0 # potem korekta, jeśli niepusta
                uni_idx += 1
              else
                found << sequence

                #ustawienie flagi, nic się nie doda do tej sekwencji
                sequence_build_finish = true
              end
            end
          end

          # korekta uni_idx
          uni_idx += sequence.unique_ngrams.length - 1
        end

        return found
      else
        raise ArgumentError, 'Excepted Document Class Object'
      end
    end

    def find_model_sequence sequences
      to_processing = (sequences.is_a? Sequence) ? [sequences] : sequences

      if to_processing.is_a? Array
        found = []

        to_processing.each { |p|
          @sequences.each { |ms|
            found << ms if ms.elements.compare p.elements
          }
        }

        return found
      else
        raise 'Excepted array'
      end
    end

    def vector_n_grams_for document

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