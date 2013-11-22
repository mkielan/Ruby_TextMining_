module TextMining
  class Ngram
    attr_accessor :symbols
    attr_accessor :prob
    attr_accessor :freq
    attr_accessor :target
    attr_accessor :n

    #
    # todo rozwiązać problem z podobieństwem (redukcja symboli), np. miara Levensteina
    # todo podobieństwo wyznaczać dzięki stosunkowi: odległość Levenstein/długość ciągóws
    # todo wziąć pod uwagę usunięcie znaków interpunkcyjnych itd.
    def initialize target, n = 1, regex = / /
      @target = target
      @prob = []
      @freq = []
      @regex = regex
      @n = n

      reload_symbols
      calculate
    end

    #
    # Find element at symbols list.
    #
    def find element #todo using levenstein
      if element.length == @n
        (0..(@symbols.length - 1)).each { |i|
          return i if ((element.compare @symbols[i]) == true)
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
      symbols = @target.split(@regex).each_cons(@n).to_a

      symbols.each { |s|
        test = find(s)
        @symbols << s if test.nil?
      }
    end

    #
    # Calculate ngrams for learn documents.
    #
    def calculate
      @count = 0
      @freq = Array.new(@symbols.length, 0)

      if @target.is_a? String
        single_calcuate @target
      elsif @target.is_a? Array
        @target.each { |t|
          single_calcuate t
        }
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

