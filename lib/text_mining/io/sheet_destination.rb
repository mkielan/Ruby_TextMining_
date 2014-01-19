require 'roo'
require 'spreadsheet'

require_relative '../n_grams'

module TextMining::IO
  class SheetDestination
    attr_accessor :sheet

    def initialize path = nil
      @path = path
      @book = Spreadsheet::Workbook.new #open(path, 'wb')

      @current_row = -1
    end

    def switch_sheet name = nil
      if name.nil?
        if @book.worksheets.length == 0
          @sheet = @book.create_worksheet
        else
          @sheet = @book.sheets.first
        end
      else
        @sheet = @book.worksheet name
        if @sheet.nil?
          @sheet = @book.create_worksheet(:name => name)
        end
      end
    end

    def write value, row = 0, col = 0
      switch_sheet if @sheet.nil?

      if value.is_a? NGram
        write value.symbols, row, col
        write value.freq, row, col + 1
        write value.symbol_card, row, col + 2
      elsif value.is_a? NGrams
        @current_row = row
        write 'N-gram', row, col
        write 'Freq', row, col + 1
        write 'Symbol cardinality', row, col + 2

        value.each { |ngram|
          write_next ngram
        }
      elsif value.is_a?(Fixnum) or value.is_a?(Bignum) or value.is_a?(Float)
        @sheet[row, col] = value
      else
        @sheet[row, col] = value.to_s
      end
    end

    def write_next value
      @current_row += 1
      write value, @current_row
    end

    def save
      @book.write @path
    end
  end
end
