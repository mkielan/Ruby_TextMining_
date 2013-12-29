module TextMining
  #trzeba dodać do text_mining.rb
  
  #
  # Comparison of documents
  #
  class DocumentCompare
    
    # Required for access to the n-grams
    attr_accessor :n_grams_manager
    
    def initialize n_gram_manager
      @n_grams_manager = n_gram_manager
    end
    
    #może by tak wykonać jakąś nie skończonąlistę parametrów
    # albo przyjąć że będzie tablica dokumentów do porównania
    # porównywanie dokonywane będzie na podstawie uzyskanych sekwencji
    def compare doc, doc2
      false
    end
  end
end