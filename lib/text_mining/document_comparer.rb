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

    #założenia:
    #- DocumentComparer musi mieć referencje do NGramManager-a
    #- Dodanie dokumentu do modelu zarządzanego przez NGramsManager powinno spowodować przelicznie sekwencji? bo topowe się zmienić mogą
    #
    #Porównanie dokumentów może odbyć się w ten sposób, że
    #
    # 1. tworzony jest dokument (ze stringa)
    # 2. porównywane dokumenty podane do metody compare
    # 3. dokumenty są poddawane wytworzeniu n-gramów dla przetworzonego ciała
    # 4. likwidowane są n-gramy nietopowe dla stanu z wygenerowanych sekwencji
    # 5. wyszukiwane są spełnione przez dokumenty sekwencje / ew. stopień spełnienia
    #   np. 50%, z tym, że jeżeli spełniony 1 element to uznawane to jako przypadek niereprezentatywny
    # 6. Miara powinna polegać w ten sposób, że jeżeli LS_i - zbiór spełnionych sekwencji przez i-ty dokument
    #   to wynik_porównania = |LS_1i2|/|LS_1|   (moc zbiorów)
    #   (licznik - spełnione przez pierwszy i drugi), (mianownik może suma bez powtórzeń)
    #   ewentualnie każde LS można przestawić jako suma współczynnik_spełnienia dla takiego zbioru.

    #może by tak wykonać jakąś nie skończonąlistę parametrów
    # albo przyjąć że będzie tablica dokumentów do porównania
    # porównywanie dokonywane będzie na podstawie uzyskanych sekwencji

    #
    # If return 0 then documents not similary
    #
    def compare doc1, doc2
      d1 = @n_grams_manager.find_sequences_for doc1
      d2 = @n_grams_manager.find_sequences_for doc2

      if !(d1.empty? or d2.empty?) #if documents sequences found

        #TODO
      end

      0
    end
  end
end