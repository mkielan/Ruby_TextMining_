module TextMining
  module Attachments

    #
    # Sheet Source to test
    #
    class SheetSource
      attr_accessor :current_nr
      attr_reader :header

      def initialize path, header = nil
        @book = Roo::LibreOffice.new path

        @book.default_sheet = @book.sheets[0]

        if header.nil?
          @current_nr = 0
          @header = 0
        else
          @current_nr= header
          @header = header
        end
      end

      #
      # Read next row/line.
      #
      def next
        if @book.last_row == @current_nr
          @current_nr = -1
        elsif @current_nr == 0
          @current_nr = @book.first_column
        else
          @current_nr += 1
        end

        current
      end

      #
      # Read current row/line.
      #
      def current
        if @current_nr >= @book.first_row and @current_nr <= @book.last_row
          ret = []

          ((@book.first_column)..3).each do |col|
            ret << @book.row(@current_nr)[col - 1]
          end

          ret
        end
      end

      def count
        @book.last_row - @header
      end
    end
  end
end

