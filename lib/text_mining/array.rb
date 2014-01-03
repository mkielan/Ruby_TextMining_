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
    if array.is_a? Array
      if array.length > 0 and self.length > 0 and array.length <= self.length
        i = 0

        last_good = self.length - array.length

        #ustalenie pierwszego wspólnego elementu
        until array[0] == self[i] or i == last_good or i >= self.length do
          i += 1
        end

        if i <= last_good or array.length == 1
          (0..array.length - 1).each { |e|
            return false if array[e] != self[e + i]
          }

          return true
        end
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