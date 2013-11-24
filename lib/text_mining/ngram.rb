module TextMining
  class Ngram
    attr_accessor :symbols
    attr_accessor :prob
    attr_accessor :freq
    attr_accessor :target
    attr_accessor :n

    # todo wziąć pod uwagę usunięcie znaków interpunkcyjnych itd.
    def initialize target, n = 1, regex = / /
      @target = target
      @prob = []
      @freq = []
      @regex = regex
      @n = n

      if !@target.is_a?(Array) and !@target.is_a?(SheetSource)
        @target = [@target]
      end

      puts 'reload_symbols'
      reload_symbols
      puts 'calculate'
      calculate
    end

    #
    # Find element at symbols list.
    #
    def find element
      if element.length == @n
        (0..(@symbols.length - 1)).each { |i|
          return i if ((element.compare @symbols[i]) == true)
          return i if (element.cmp_levenshtein(@symbols[i]) == true)
          #return i if element.weighted_distance(@symbols[i]) <= 1
        }
      end

      nil
    end

    #
    # Find probs for given element.
    #
    def find_prob element
      if element.is_a? Array
        (0..@symbols.length-1).each { |s|
          if element.compare @symbols[s] == true
            return @prob[s]
          end
        }
      end

      return 0
    end

    #
    # Reload symbols from model
    #
    def reload_symbols
      @symbols = []

      @target.each { |doc|
        if doc.is_a? Document
          doc = doc.body
        end
        symbols = doc.split(@regex).each_cons(@n).to_a
        #todo usunięcie znaków przystankowych etc.

        symbols.each { |s|
          test = find(s)
          @symbols << s if test.nil?
        }
      }
    end

    #
    # Calculate ngrams for learn documents.
    #
    def calculate
      @count = 0
      @freq = Array.new(@symbols.length, 0)

      if @target.is_a? Array
        @target.each { |t|
          single_calcuate t
        }
      else
        single_calcuate @target
      end

      # mapping of all the results on probability
      @prob = @freq
      @prob = @prob.map! { |x| x.to_f / @count }
    end

    protected
    #
    # Cakculate for single learn document.
    #
    def single_calcuate single
      single = single.body if single.is_a? Document

      tokens = single.split(@regex)
      tmp = []

      (0..(tokens.length - 1)).each { |i|
        tmp << tokens[i]
        tmp.delete_at(0) if tmp.length > @n

        if tmp.length == @n
          #znalezienie takiej n-ki w n-gramie

          index = find tmp
          if index.nil?
            @symbols << tmp
            @freq << 1
          else
            @freq[index] += 1
          end
          tmp.delete_at 0
          @count += 1
        end
      }
    end
  end
end

