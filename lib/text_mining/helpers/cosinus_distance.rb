
module TextMining::Helpers
  class CosinusDistance
    def self.similarity array1, array2
      if !array1.is_a? Array or !array2.is_a? Array
        raise ArgumentError, 'inputs must be Array'
      end
      raise 'arrays must have equal length' if array1.length != array2.length
      l = 0
      array1.length.times { |i| l += array1[i] * array2[i] }
      m = Math.sqrt(euclides(array1)) * Math.sqrt(euclides(array2))

      l.to_f / m.to_f
    end

    def self.distance array1, array2
      1 - similarity(array1, array2)
    end

    def self.euclides array
      raise ArgumentError, 'array is not Array Class object' if !array.is_a? Array

      sum = 0
      array.each { |n|
        sum += n**2
      }
      sum
    end
  end
end
