module TextMining
  
  #
  # Sequence of the elements (ngrams) with support recount.
  #
  class Sequence
    attr_reader :elements
    attr_reader :support
    
    def initialize first = nil
      @elements = []
      @supports = []
      @support = 0
      
      add_to_front first if !first.nil?
    end
    
    def add_conditionally ngram, support = 0
      if length == 0 or starts_from ngram
        add_to_front ngram, support
      elsif ends_at ngram
        add_to_end ngram, support
      else
        false
      end
      
      true
    end
    
    def add_to_front element, support = 0
      @elements.unshift element
      @supports.unshift support
    end
    
    def add_to_end element, support = 0
      @elements << element
      @supports << support
    end
    
    #
    # Return <b>true</b> if sequence contain other sequence,
    # else <b>false</b>.
    #
    def contain other
      if other.is_a? Sequence
        return @elements.order_containing other.elements
      else other.is_a? Array
        return @elements.order_containing other  
      end
      
      false
    end
    
    #
    # Returns elements of sequence without repeats components of elements
    #
    def without_reps
      #TODO
    end
    
    def starts_from ngram
      extremity :begin
    end
    
    def ends_at ngram
      extremity :end
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
      @support = @supports.sum.to_f / @supports.length.to_f
    end
    
    #
    # Check if sequence start or finish with components of entrance n-gram.
    #
    def extremity which = :begin
      seq_ngram_element = which == :begin ? @elements.first : last
      
      return false if @elements.length == 0
      return true if seq_ngram_element == ngram
      
      ngram.each { |el|
        if el == seq_ngram_element[0]
          (0..seq_ngram_element.length - 1).each { |i|
            return false if seq_ngram_element[i] != el
          }
          
          return true
        end
      }
      
      false
    end
  end
end