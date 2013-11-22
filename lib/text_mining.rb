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

    def initialize source
      @source = source

    end

    # Przed wszystkim pobrać ciąg testowy i uzyskać ngramy dla przetwarzania
    #
    # Pobieranie kolejnuych dokumentów:
    # 1. Utworzenie obiektów
    # 2. W trakcie tworzenia obiektów następuje wyciągnięcie ze stringów
    #    za pomocą wyrażeń regularnych daty, oraz numerów
    # 3. Następnie dokumenty są przetwarzane przez metodę processing tej klasy
    # 4. Przetworzony dokument może być zmapowany na formę wyjściową
    def run
      while row = @source.next

        doc = Document.new row[0]

        puts '###'
        puts doc
        puts 'Numbers:'
        puts doc.find_numbers.to_s
        #row.each { |col|
        #  puts col.to_s
        #}
      end
    end

    protected
    #
    # Processing document specified in the parameter
    # Using ngrams, measure the Levenshtein and regex
    def processing document

    end
  end
end
