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
        if value.is_a? TextMining::NGrams
          file.write("NGram\tFreq\tsymbol cardinality\n")
          # write header
          (0..value.length - 1).each { |i|
            tmp = "#{value[i].symbols}\t#{value[i].freq}\t#{value[i].symbol_card}"
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
