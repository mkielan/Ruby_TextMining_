require 'test/unit'

require_relative '../test/test_text_mining_helper'

include TextMining

class NgramTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @text = 'Major Halbe próbuje nakłonić oskarżonego o kłamstwo partyzanta by pozyskał informacje o zrzucie żołnierzy z Londynu'
    @ngram1 = Ngram.new @text, 1
    @ngram2 = Ngram.new @text, 2
    @ngram3 = Ngram.new @text, 3
    @ngram4 = Ngram.new @text, 4
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end


  def test_find

  end

  def test_reload_symbols


    assert_equal @ngram1.symbols.length, 15
    assert_equal @ngram2.symbols.length, 15
    assert_equal @ngram3.symbols.length, 14
    assert_equal @ngram4.symbols.length, 13
  end

  def test_calculate

  end
end