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
  def is_numeric?
    !(self =~ /^-?[0-9]+[,|.]?[0-9]*$/).nil?
  end

  #
  # Check if string is unit
  #
  def is_unit?
    !(self =~ %r{^[a-zA-Z]{,3}?[ ]?[/]?[ ]?[a-zA-Z]{,3}$}).nil?
  end

  #
  # Weighted Levenshteins distance from other word.
  #
  def weighted_distance other
    raise '' if !other.is_a? String

    distance = Levenshtein.distance self, other

    delta = (self.length - other.length).abs + 1

    distance.to_f / delta.to_f
  end

  #
  # Checks if the string is similar to another.
  # It is resistant case sensitive.s
  #
  def similar_to other, accept = 0.34
    distance = Levenshtein.normalized_distance self.downcase, other.downcase

    return distance <= accept
  end

  def split_words
    self.split(/[ ]+/)
  end

  #
  # Types:
  #  - \D - znak nie będący cyfrą
  #  - \d - znak cyfra
  #  - \S - nie biały znak
  #  - \s - biały znak
  #  - \w - literta lub cyfra
  #  - \W - anni litera, ani cyfra
  # patrz wyrażenia regularne w ruby.
  #
  def replace_punctuation intra_word = false, replace = ''
    type = '\D'
    punctuation = '[.|,]' # |-|:|\'
    rgx = Regexp.new punctuation

    if intra_word
      (self.split rgx).sum
    else
      s = ''
      tmp = self
      p = type + punctuation + type if !intra_word

      while !tmp.nil? && !tmp.empty?
        part = tmp.partition Regexp.new(p)

        s += part[0]
        s += part[1].gsub rgx, replace
        tmp = part[2]
      end

      s.gsub! Regexp.new('^' + punctuation), ''
      s.gsub! Regexp.new(punctuation + '$'), ''

      s
    end
  end

  def remove_punctuation intra_word = true
    replace_punctuation intra_word
  end

  def remove_punctuation! intra_word = true
    tmp = self.remove_punctuation intra_word
    self.clear
    self.insert 0, tmp
  end
end