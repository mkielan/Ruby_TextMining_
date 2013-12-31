require_relative '../n_grams'

module TextMining::Attachments

  # Helper to save data to file.
  class FileDestination
    attr_accessor :path

    def initialize path
      @path = path
    end

    def write value
      File.open(@path, 'w') do |file|
        if value.is_a? TextMining::NGram
          tmp = '          '

          # write header
          (0..value.symbols.length - 1).each { |i|
            tmp += "%#{5 + value.symbols[i].to_s.length}s" % value.symbols[i].to_s
          }
          file.write(tmp + "\n")

          (0..value.cardinalities.length - 1).each { |r|
            tmp = '%7s' % ('doc' + (r + 1).to_s)

            cardinality = value.cardinalities[r]
            (0..cardinality.length - 1).each { |c|
              length = 5 + value.symbols[c].to_s.length
              tmp += "%#{length}s" % cardinality[c].to_s
            }

            file.write(tmp + "\n")
          }
        elsif value.is_a? TextMining::Freqs
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
