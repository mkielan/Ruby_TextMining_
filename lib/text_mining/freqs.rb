module TextMining
  module Tools
    class Freqs < Array
      def to_s
        str = ''

        if self.length > 0 and (self[0].is_a? Hash)
          str += self.first.keys.to_s + "\n"
        end

        self.each { |s|
          if s.is_a? Hash
            str += s.values.to_s
          else
            str += s.to_s
          end

          str += "\n"
        }

        str
      end

      def best percent
        if percent.is_a? Numeric
          if 0.0000 < percet and percent <= 1.000
            many = (length * percent).to_int
            many = 1 if many < 1

            return self[0, many - 1]
          else
            raise 'Excepted value between range (0, 1>'
          end
        else
          raise 'Excepted float value'
        end
      end
    end
  end
end
