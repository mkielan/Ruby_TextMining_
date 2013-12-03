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

        (0..self.length-1).each { |i|
          return false if not self[i].similar_to(array[i])
        }

        return true
      end
    end

    raise 'Excepted array object'
  end

  def sum
    self.inject { |sum, x| sum + x }
  end
end