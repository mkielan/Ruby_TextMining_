require 'roo'

require 'text_mining/version'

require 'text_mining/array'
require 'text_mining/string'
require 'text_mining/document'
require 'text_mining/ngram'
require 'text_mining/ngrams'

require 'text_mining/attachments/sheet_source'
require 'text_mining/attachments/sheet_destination'
require 'text_mining/attachments/file_destination'

# Tools
require 'text_mining/tools/n_gram'
require 'text_mining/tools/chart_display'

# MapReduce można użyć do określenia, które ciągi użyć jako testujące lub ustalenie zbioru słów funkcyjnych.
# Przykładowo stopwords mogą być generowane automatycznie na podstawie ciągów, które są różne dla nich

module TextMining
  class TextMining
    attr_reader :ngrams

    def initialize source, lrn_src
      @source = source
      @lrn_src = lrn_src
    end

    # Pobieranie kolejnuych dokumentów:
    # 1. Utworzenie obiektów
    # 2. W trakcie tworzenia obiektów następuje wyciągnięcie ze stringów
    #    za pomocą wyrażeń regularnych daty, oraz numerów
    # 3. Następnie dokumenty są przetwarzane przez metodę processing tej klasy
    # 4. Przetworzony dokument może być zmapowany na formę wyjściową
    def run
      #puts 'Prepare ngrams'
      #prepare_ngrams
      #puts 'Ngrams prepared'

      puts 'Processing documents'
      while row = @source.next
        doc = Document.new row[0]

        processing doc
      end

      puts 'Complete'
    end

    protected
    #
    # Preparing n-grams from learn documents.
    #
    def prepare_ngrams
      test_docs = []

      # Reading learn docs from source.
      while row = @lrn_src.next
        test_docs << Document.new(row[0])
      end

      @ngrams = Ngrams.new(test_docs)
    end

    #
    # Processing document specified in the parameter
    # Using ngrams, measure the Levenshtein and regex
    def processing document
      puts '###'
      puts document
      puts '# transform body:'
      puts document.tr_body

      puts '# dates: '
      puts document.dates
      puts '# numbers:'
      puts document.numbers
      puts '# units: '
      puts document.units

      return #tymczasowo

      words = document.tr_body.split_words

      #for each n-grams
      (1..2).each { |n|
        tmp = []
        words.each { |x|
          tmp << x
          tmp.delete_at 0 if tmp.length > n

          #search n-grams to find

          # znalezienie takiej nki
          # sprawdzenie czy jest dość często taka konfiguracja
          # jeśli tak to dodać do tablicy nazw, i dać znacznik w tekście
          # trzeba sensownie wykorzystać znacznik w tr_body, aby nie model mógł rozróżniać wartości,
          # poprostu traktował zb jako poszczególny model w przyszłości, podobnie jednostki powinny być rozróżnialne przez model.
          # typy tj. data i liczby mogą być zastąpione odpowiednim kryptonimiem

          # uni gram może przydać się do usunięcia słów funkcyjnych,
          # jeśli słowo jest na liście słów funkcyjnych danego języka
          # i nie zostało zakwalifikowane do grupy to można odjąć je od ciągu jako nieistotne z dużym prawdopodobieństwem
        }
      }
    end
  end
end
