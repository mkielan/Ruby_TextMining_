
module TextMining
  class Document


    def initialize body
      @body = body
      @document_rgx = '<num(x)/>'

      # todo wywołanie metod znajdowania, aby odnaleźć elementy
      # wyłapanie numerów przed datami?
      # szukanie numerów
      # szukanie jednostek
    end

    def dates

    end

    def to_s
      @body.to_s
    end

    #
    # Find numbers and return array with replaced numbers with id,
    # array of found numbers, and patern of id.
    #
    def find_numbers #replace=nil
      numbers = []

      text = @body
      buf = ''
      onwards = true
      number = 0
      while onwards
        partition = text.partition /[-|+]?[0-9]+[.|,]?[0-9]*/

        buf += partition[0]
        if partition[1].is_numeric?
          numbers << partition[1]
          puts 'Unit: ' + partition[2].find_unit.to_s

          buf += @document_rgx.gsub('x', number.to_s)
          number += 1
        else
          buf += partition[1]
        end
        buf += partition[2]

        text = partition[2]
        #partion[0] - poszukiwanie nazwy
        #partion[2] - poszukiwanie jednostki

        onwards = !partition[2].empty?
      end

      [buf, numbers, @document_rgxs]
    end
  end

  # może zrobić <num(x, value)/>

  #
  # Można szukać jednostek po znalezieniu numerów
  def find_unit
    if not self.empty?
      partition = self.partition %r{^[a-zA-Z]{,3}?[ ]?[/]?[ ]?[a-zA-Z]{,3}[ |.|,|:|;]*}

      if not partition[1].empty?
        partition = self.partition %r{^[a-zA-Z]{,3}?[ ]?[/]?[ ]?[a-zA-Z]{,3}}
        if partition[1].is_unit?
          return partition[1]
        end
      end
    end
  end

  def find_date

  end
end
