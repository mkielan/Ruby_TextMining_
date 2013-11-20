
#require '../../lib/tokens/token'

module TextMining

    #
    # Sheet Source to test
    #
    class SheetSource

      attr_accessor :current_nr

      def initialize path
        @book = Roo::LibreOffice.new path

        @book.default_sheet = @book.sheets[0]

        @current_nr = 0
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
        #puts @current_nr.to_s + "|" + @book.first_row.to_s + "; " +  @book.last_row.to_s
        if @current_nr >= @book.first_row and @current_nr <= @book.last_row
          ret = []
          #((@book.first_column)..(@book.last_column)).each do |col|
          ((@book.first_column)..3).each do |col|
            ret << @book.row(@current_nr)[col - 1]
          end

          ret
        end
      end
    end
end

