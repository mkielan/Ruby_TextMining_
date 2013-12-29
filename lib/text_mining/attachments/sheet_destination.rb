require 'roo'
require 'spreadsheet'

require_relative '../n_grams'

module TextMining::Attachments
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
      if value.is_a? Tools::NGram
        # write header
        save
        (0..value.symbols.length - 1).each { |i|
          write(value.symbols[i].to_s, row, i + 1)
        }

        # write values
        (0..value.cardinalities.length - 1).each { |r|
          write 'doc' + (r + 1).to_s, r + 1, col

          freq = value.cardinalities[r]
          (0..freq.length - 1).each { |c|
            write(freq[c], r + row + 1, c + col + 1)
          }
          save
          puts r
        }
      else
        @sheet[row, col] = value.to_s
      end

      save
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
