require 'roo'

require 'text_mining/version'
require 'text_mining/string'
require 'text_mining/sheet_source'
require 'text_mining/document'
require 'text_mining/range'
require 'text_mining/ngram'
require 'text_mining/ngrams'

module TextMining
  class TextMining


    def initialize source
      @source = source

    end

    def run
      while row = @source.next

        doc = Document.new row[0]

        puts '###'
        puts doc
        puts 'Numbers:'
        puts doc.numbers.to_s
        #row.each { |col|
        #  puts col.to_s
        #}
      end
    end
  end
end
