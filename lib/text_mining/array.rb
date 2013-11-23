require 'levenshtein'

class Array

  #
  # Copare array with other.
  #
  def compare array
    if array.is_a? Array
      if self.length == array.length
        (0..self.length).each { |i|
          if self[i] != array[i]
            return false
          end
        }

        return true
      end

      return false
    end

    raise 'Excepted array object'
  end

  #
  # Return array of distances during arrays with Levenstein algorithm
  #
  def cmp_levenshtein array
    if array.is_a? Array
      if self.length == array.length
        #distances = []
        distances = 0;

        (0..self.length-1).each { |i|
          distances += self[i].weighted_distance(array[i])
          #distances << Levenshtein.distance(self[i], array[i])
        }


        return (distances.to_f / array.length.to_f) <= 0.5
        #return distances
      end
    end

    raise 'Excepted array object'
  end
end