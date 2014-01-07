module TextMining

  #
  # Sequence of the elements (ngrams) with support recount.
  #
  class Sequence
    private
    alias :supper_eql? eql?
    protected
    attr_writer :elements

    public
    attr_reader :elements
    attr_reader :support

    def initialize first = nil
      @elements = []
      @support = 0

      add_to_front first if !first.nil?
    end

    def add ngram
      if ngram.is_a? NGram
        if length == 0 or starts_from ngram
          add_to_front ngram
          return true
        elsif ends_at ngram
          add_to_end ngram
          return true
        end
      end

      false
    end

    def add_to_front element
      @elements.unshift element
      unique_ngrams!
      support_recount
    end

    def add_to_end element
      @elements << element
      unique_ngrams!
      support_recount
    end

    #
    # Return <b>true</b> if sequence contain other sequence,
    # else <b>false</b>.
    #
    def contain other
      return true if self.supper_eql? other

      if other.respond_to? :length
        if other.length == 0
          return false
        end
      end

      self_elements = []
      @elements.each { |e| self_elements << e.symbols }

      if other.is_a? Sequence
        return self_elements.order_containing other.elements
      elsif other.is_a? NGram
        return self_elements.order_containing [other.symbols]
      elsif other.is_a? Array
        if other[0].is_a? NGram
          arr = []
          other.each { |a| arr << a.symbols.dup }

          return self_elements.order_containing arr
        end
      end

      false
    end

    def starts_from ngram
      extremity ngram, :begin
    end

    def ends_at ngram
      extremity ngram, :end
    end

    def to_s
      @elements.to_s
    end

    def length
      @elements.length
    end

    def expanded_support ngram
      if ngram.is_a? NGram
        sum = ngram.freq
        @elements.each { |i| sum += i.freq }

        @support = sum.to_f / (length + 1).to_f
      else
        raise(ArgumentError, ': ngram should be object of NGram Class')
      end
    end

    def clone
      seq = Sequence.new

      seq.elements = self.elements.clone
      seq
    end

    def to_write
      a = '['
      @elements.each { |e| a += e.symbols.to_s }
      a += ']'
    end

    def unique_ngrams
      ret = @elements.clone

      i = 0
      while i <= (ret.length - 1) do
        if i > 0
          if ret[i - 1].symbols.order_containing ret[i].symbols
            ret.delete_at i
            next
          end
        end

        if i < ret.length - 1
          if ret[i + 1].symbols.order_containing ret[i].symbols
            ret.delete_at i
            next
          end
        end

        i += 1
      end

      ret
    end

    def unique_ngrams!
      @elements = unique_ngrams
    end

    def unique_elements
      tmp = @elements.clone

      (0..tmp.length - 2).each { |i|
        idx = 0
        (0..tmp.length - 1).each { |j|

          if tmp[i].symbols[j] == tmp[i + 1].symbols[0]
            idx = tmp[i].symbols.length - j
            break
          end
        }

        idx.times { tmp[i + 1].symbols.delete_at 0 }
      }

      ret = []
      tmp.length.times { |i| ret.concat tmp[i].symbols }
      ret
    end

    def ==(y)
      return false if !y.is_a? Sequence
      return false if self.length != y.length

      self.length.times { |i|
        return false if self.elements[i] != y.elements[i]
      }

      true
    end

    def !=(y)
      not (self == y)
    end

    private

    #
    # Recount support for sequence. 
    # Based on elements support.
    #
    def support_recount
      sum = 0
      @elements.each { |i| sum += i.freq }

      @support = sum.to_f / length.to_f
    end

    #
    # Check if sequence start or finish with components of entrance n-gram.
    #
    def extremity ngram, which = :begin
      return false if ngram.nil? or @elements.length == 0

      if which == :begin
        other = @elements.first.symbols
        element = ngram.symbols
        return false if other.order_containing element
      else
        element = @elements.last.symbols
        other = ngram.symbols

        if element.order_containing other
          return false
        end
      end

      return false if element == other

      if other.is_a? Array
        last_element = nil

        #ustalenie ostatniego wspólnego
        (0..element.length - 1).reverse_each { |i|
          if other.first == element[i]
            last_element = i
            break
          end
        }

        if !last_element.nil?
          (last_element..element.length - 1).each { |i|
            return false if other[i - last_element] != element[i]
          }

          return true
        end
      end

      false
    end
  end
end