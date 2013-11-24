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
      @data_rgx = '<date/>'
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


      text = @tr_body.nil? ? @body : @tr_body
      buf = ''
      number = 0
      while !text.nil? && !text.empty?
        partition = text.partition /[-|+]?[0-9]+[.|,]?[0-9]*/

        #partion[0] - poszukiwanie nazwy
        buf += partition[0]
        if partition[1].is_numeric?
          numbers << partition[1]

          #puts 'Unit: ' + partition[2].find_unit.to_s
          buf += @num_rgx.gsub('x', number.to_s)

          result = find_unit partition[2], number
          if !result.nil?
            units << result[0]
            buf += result[1]
            partition[2] = result[2]
          end


          number += 1
        else
          buf += partition[1]
        end
        #partion[2] - poszukiwanie jednostki

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

          ts = partition[0] + @unit_rgx.gsub('x', number.to_s)
          return [partition[1], ts, partition[2]]
          #return partition[1]
        end
      end
    end
  end

  #
  # Find dates at text document.
  #
  def find_dates
    #todo poprawić regex
    rgx = %r{([0]?[1-9]|[1|2][0-9]|[3][0|1])[./-]([0]?[1-9]|[1][0-2])[./-]([0-9]{4}|[0-9]{2})}
    @dates = []
    find @dates, @data_rgx, rgx
  end

  def find array, replace, rgx
    buf = ''
    number = 0
    text = @body

    while !text.nil? and !text.empty?
      partition = text.partition rgx

      buf += partition[0] if !partition[0].nil?
      if !partition[1].empty?
        array << partition[1]
        buf += replace.gsub 'x', number.to_s
        #todo próba normalizacji (zunifikowania zapisu) daty
      end
      buf += partition[2] if !partition[2].nil?

      text = partition[2]
      number += 1
    end

    @tr_body= buf if buf.length > 0
  end

  public
  #
  # Override to_s method.
  #
  def to_s
    @body.to_s
  end
end
