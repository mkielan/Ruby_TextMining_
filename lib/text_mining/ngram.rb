module TextMining
  class Ngram
    attr_accessor :symbols
    attr_accessor :prob
    attr_accessor :freq
    attr_accessor :target
    attr_accessor :n

    #
    # todo rozwiązać problem z mapowaniem wielu dokumentów testowych
    # todo rozwiązać problem z podobieństwem (redukcja symboli), np. miara Levensteina
    # todo
    #
    def initialize target, n = 1, regex = / /
      @target = target
      @prob = []
      @freq = []
      @regex = regex
      @n = n

      reload_symbols
      calculate
    end

    def single_calcuate
      # dla pojedynczego, w calculate wiele
    end

    def calculate
      @freq = Array.new(@symbols.length, 0)
      tokens = @target.split(@regex)

      tmp = []
      @count = 0

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

      #zmapowanie wszystkich wyników na prawdopodobieństwa
      @prob = @freq
      @prob = @prob.map! { |x| x.to_f / @count }
    end

    #
    # Find element at symbols list
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
    # Symbols from model
    #
    def reload_symbols
      symbols = @target.split(@regex).each_cons(@n).to_a

      @symbols = []

      symbols.each { |s|
        test = find(s)
        @symbols << s if test.nil?
      }
    end

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
  end
end

