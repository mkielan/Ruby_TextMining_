require 'roo'

require 'text_mining/version'

require 'text_mining/array'
require 'text_mining/string'
require 'text_mining/sheet_source'
require 'text_mining/document'
require 'text_mining/ngram'
require 'text_mining/ngrams'

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
      puts 'Prepare ngrams'
      prepare_ngrams
      puts 'Ngrams prepared'

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
      puts 'transform body:'
      puts document.tr_body
    end
  end
end
