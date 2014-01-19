
module TextMining::Helpers
  class Distance
    def euclides x, y
      if !x.is_a? Array or !y.is_a? Array
        raise ArgumentError, 'x or y is not Array'
      end

      raise 'x and y are not have the same length' if x.length != y.length

      sum = 0
      x.length.times { |i|
        sum += (x[i] - y[i])**2
      }

      Math.sqrt sum
    end

    def city x, y
      if !x.is_a? Array or !y.is_a? Array
        raise ArgumentError, 'x or y is not Array'
      end

      raise 'x and y are not have the same length' if x.length != y.length

      sum = 0
      x.length.times { |i|
        sum += (x[i] - y[i]).abs
      }

      Math.sqrt sum
    end
  end
end
