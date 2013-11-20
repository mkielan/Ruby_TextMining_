
module TextMining
  class Document
    def initialize body
     @body = body
    end

    def dates

    end

    def numbers
      find_numbers
    end

    def to_s
      @body.to_s
    end

    def find_numbers replace=nil
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

          buf += "<number(#{number})/>"
        else
          buf += partition[1]
        end
        buf += partition[2]

        text = partition[2]
        #partion[0] - poszukiwanie nazwy
        #partion[2] - poszukiwanie jednostki

        onwards = !partition[2].empty?
      end

      [buf, numbers, '<!number(index)/>']
    end
  end

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
end
