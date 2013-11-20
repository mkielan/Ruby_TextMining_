#
# Expand of String Class
#
class String

  #
  # Checks if string can be integer
  #
  def is_int?
    !(self =~ /^-?[0-9]+$/).nil?
  end

  #
  # Checks if string can be word
  #
  def is_word?
    !(self =~ /^[a-zA-Z]+$/).nil?
  end

  #
  # Checks if string can be phrase
  #
  def is_phrase?
    !(self.split.length > 1 && self =~ /[a-zA-Z]+/).nil?
  end

  #
  # Check if string can be date
  #
  def is_date?
    begin
      Date.parse(self)

      return true
    rescue
      return false
    end
  end

  #
  # Check if string can be numeric
  #
  def  is_numeric?
    !(self =~ /^-?[0-9]+[,|.]?[0-9]*$/).nil?
  end

  def is_unit?
    !(self =~ %r{^[a-zA-Z]{,3}?[ ]?[/]?[ ]?[a-zA-Z]{,3}$}).nil?
  end
end