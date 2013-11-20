require 'test/unit'

require_relative '../test/test_text_mining_helper'

include TextMining

class NgramsTest < Test::Unit::TestCase

  def setup
    @text = 'Ala ma kota a kot ma Ale'
    @ngram = Ngrams.new @text
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_ngrams
    a = @ngram.ngrams(3)
    puts a.symbols

  end
end