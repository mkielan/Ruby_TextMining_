module TextMining
  class Ngram
    attr_accessor :symbols
    attr_accessor :prob
    attr_accessor :target
    attr_accessor :n

    def initialize target, n = 1, regex = / /
      @target = target
      @prob = []
      @regex = regex
      @n = n

      reloadSymbols
      calculate
    end

    def calculate
      #tutaj można użyć marę levenshteina (aby się nie powtarzał, np po określeniu wszystkich częstości, aby nie sptawdzać za każdym dodaniem(zmniejsza złożoność))
      @probs = Array.new(@symbols.length) { Array.new(@symbols.length, 0) }

      tokens = @target.split(@regex)


      tmp = []
      (@n..tokens.length).each { |i|
        tmp << tokens[i]
        tmp.delete_at(0) if tmp.length > @n

        if tmp.length == @n
          #sprawdzenie czy jest taka n-ka w ngramie

        end
      }
    end

    def find el
      if el.length == @n
        @symbols.each { |x|
          #może array to set, albo rozserzyć klasę arrays
        }
      end
    end

    def reloadSymbols
      @symbols = @target.split(@regex).each_cons(@n).to_a
    end

    def find_prob
      #tutaj można użyć marę levenshteina
    end

    def find_probs from, to

    end
  end
end

