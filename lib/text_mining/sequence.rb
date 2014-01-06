module TextMining
  
  #
  # Sequence of the elements (ngrams) with support recount.
  #
  class Sequence
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

      support_recount
    end
    
    def add_to_end element
      @elements << element

      support_recount
    end
    
    #
    # Return <b>true</b> if sequence contain other sequence,
    # else <b>false</b>.
    #
    def contain other
      return true if self == other

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
    
    private
    #
    # Recount support for sequence. 
    # Based on elements support.
    #
    def support_recount
      sum = 0
      @elements.each { |i| sum += i.freq}

      @support = sum.to_f / length.to_f
    end
    
    #
    # Check if sequence start or finish with components of entrance n-gram.
    #
    def extremity ngram, which = :begin
      if which == :begin
        seq_ngram_element = @elements.first.symbols
        other = ngram.symbols
      else
        seq_ngram_element = @elements.last.symbols.reverse
        other = ngram.symbols.reverse
      end

      return false if @elements.length == 0
      return true if seq_ngram_element == other

      if other.is_a? Array
        other.length.times { |i|
          if other[i] == seq_ngram_element[0]
            (i + 1..other.length - 1).each { |j|
              return false if seq_ngram_element[j - i - 1] == other[j]
            }

            return true
          end
        }
      end

      false
    end
  end
end