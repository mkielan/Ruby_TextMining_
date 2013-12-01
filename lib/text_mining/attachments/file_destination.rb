require_relative '../tools/n_gram'

module TextMining::Attachments
  class FileDestination
    attr_accessor :sheet

    def initialize path
      @path = path
    end

    def write value
      File.open(@path, 'w') do |file|
        if value.is_a? TextMining::Tools::NGram
          tmp = '          '

          # write header
          (0..value.symbols.length - 1).each { |i|
            tmp += "%#{5 + value.symbols[i].to_s.length}s" % value.symbols[i].to_s
          }
          file.write(tmp + "\n")

          (0..value.cardinalities.length - 1).each { |r|
            tmp = "%7s" % ('doc' + (r + 1).to_s)

            cardinality = value.cardinalities[r]
            (0..cardinality.length - 1).each { |c|
              length = 5 + value.symbols[c].to_s.length
              tmp += "%#{length}s" % cardinality[c].to_s
            }

            file.write(tmp + "\n")
          }
        elsif value.is_a? TextMining::Tools::Freqs
          file.write value
        elsif value.is_a? Array
          value.each { |v|
            file.write v
            file.write "\n"
          }
        else
          file.write value
        end
      end
    end
  end
end
