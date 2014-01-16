module TextMining
  #trzeba dodać do text_mining.rb
  
  #
  # Comparison of documents
  #
  class DocumentComparer
    
    # Required for access to the n-grams
    attr_accessor :n_grams_manager
    
    def initialize n_gram_manager
      @n_grams_manager = n_gram_manager
    end

    def compare doc1, doc2
      if !doc1.is_a? Document or !doc2.is_a? Document
        v1 = @n_grams_manager.vector_n_grams_for doc1
        v2 = @n_grams_manager.vector_n_grams_for doc2

        return TextMining::Helpers::CosinusDistance.distance v1, v2
      else
        raise ArgumentError, 'one or two parametrs are not Document class object'
      end
    end
  end
end