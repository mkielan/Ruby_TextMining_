module TextMining
  class Document
    attr_reader :body
    attr_reader :numbers
    attr_reader :units
    attr_reader :dates
    attr_reader :num_rgx
    attr_reader :unit_rgx
    attr_reader :date_rgx
    attr_accessor :tr_body

    def initialize body
      @body = body
      @num_rgx = '<num(x)/>'
      @data_rgx = '<date(x)/>'
      @unit_rgx = '<unit(x)/>'

      find_dates
      find_numbers_units

      # todo wywołanie metod znajdowania, aby odnaleźć elementy

      # szukanie jednostek , jednostki daty, i umery w znaczniki
    end

    protected
    #
    # Find numbers and return array with replaced numbers with id,
    # array of found numbers, and patern of id.
    #
    def find_numbers_units
      numbers = []
      units = []

      text = @body
      buf = ''
      number = 0
      while !text.nil?
        partition = text.partition /[-|+]?[0-9]+[.|,]?[0-9]*/

        #partion[0] - poszukiwanie nazwy
        buf += partition[0]
        if partition[1].is_numeric?
          numbers << partition[1]

          result = find_unit partition[2], number
          if !result.nil?
            units << result[0]
            partition[2] = result[1]
          end

          #puts 'Unit: ' + partition[2].find_unit.to_s

          buf += @num_rgx.gsub('x', number.to_s)
          number += 1
        else
          buf += partition[1]
        end
        #partion[2] - poszukiwanie jednostki
        buf += partition[2]

        text = partition[2]
      end

      @numbers = numbers
      @units = units
      @tr_body = buf
      #[buf, numbers, @document_rgxs]
    end
  end

  #
  # Return two dimensial array with
  # 1 - found unit
  # 2 - other text
  def find_unit text, number
    if not text.empty?
      partition = text.partition %r{^[a-zA-Z]{,3}?[ ]?[/]?[ ]?[a-zA-Z]{,3}[ |.|,|:|;]*}

      if not partition[1].empty?
        partition = text.partition %r{^[a-zA-Z]{,3}?[ ]?[/]?[ ]?[a-zA-Z]{,3}}
        if partition[1].is_unit?

          ts = partition[0] + @unit_rgx.gsub('x', number.to_s) + partition[2]
          return [partition[1], ts]
          #return partition[1]
        end
      end
    end
  end

  #
  # Find dates at text document.
  # todo
  def find_dates

  end

  public
  #
  # Override to_s method.
  #
  def to_s
    @body.to_s
  end
end
