require_relative '../tools/n_gram'

module TextMining
  module Attachments
    class FileDestination
      attr_accessor :sheet

      def initialize path
        @path = path
      end

      def write value
        File.open(@path, 'w') do |file|
          if value.is_a? Tools::NGram
            tmp = '       '

            # write header
            (0..value.symbols.length - 1).each { |i|
              tmp += "%#{3 + value.symbols[i].to_s.length}s" % value.symbols[i].to_s
            }
            file.write(tmp + "\n")

            (0..value.freqs.length - 1).each { |r|
              tmp = "%7s" % ("doc" + (r + 1).to_s)

              freq = value.freqs[r]
              (0..freq.length - 1).each { |c|
                length = 3 + value.symbols[c].to_s.length
                tmp += "%#{length}s" % freq[c].to_s
              }

              file.write(tmp + "\n")
            }
          else
            file.write value
          end
        end
      end
    end
  end
end
