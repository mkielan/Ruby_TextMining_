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

    raise ArgumentError, 'Excepted array object'
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

    raise ArgumentError, 'Excepted array object'
  end

  #
  # Check if self contain other array with order
  #
  def order_containing array
    return false if array.nil?

    if array.is_a? Array
      if array.length > 0 and self.length > 0 and  array.length <= self.length

        self.length.times { |i|
          last = nil
          start = i
          array.length.times { |j|
            if start >= self.length or self[start] != array[j]
              break
            end
            last = j + 1
            start += 1
          }

          return true if last == array.length
        }
      end
    else
      raise ArgumentError, 'Excepted Array class object!'
    end

    false
  end

  #def find_order_containing

  #end

  def sum
    self.inject { |sum, x| sum + x }
  end
end