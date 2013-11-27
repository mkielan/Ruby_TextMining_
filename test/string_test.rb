require 'test/unit'
require 'date'
require_relative '../test/test_text_mining_helper'


class StringTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_is_int
    assert_equal ''.is_int?, false
    assert_equal '1'.is_int?, true
    assert_equal '123'.is_int?, true
    assert_equal 'sadff 1234'.is_int?, false
  end

  def test_is_word
    assert_equal 'test'.is_word?, true

    assert_equal 'test test'.is_word?, false
    assert_equal '12'.is_word?, false
    assert_equal '2013-01-11'.is_word?, false
    assert_equal 'test 12'.is_word?, false
  end

  def test_is_date
    assert_equal '2013-10-01'.is_date?, true
    assert_equal '2013-10-01 12:12'.is_date?, true

    assert_equal 'test'.is_date?, false
    assert_equal '1'.is_date?, false
  end

  def test_is_phrase
    assert_equal 'test'.is_phrase?, true
    assert_equal 'test test'.is_phrase?, true
  end

  def test_is_numeric
    assert_equal '12'.is_numeric?, true
    assert_equal '12.12'.is_numeric?, true

    assert_equal 'test'.is_numeric?, false
    assert_equal 'test 123'.is_numeric?, false
  end

  def test_is_unit
    assert_equal '/cm'.is_unit?, true
    assert_equal '/min'.is_unit?, true
    assert_equal '/ min'.is_unit?, true
    assert_equal '/minut'.is_unit?, false
    assert_equal 'min'.is_unit?, true
    assert_equal 'cm/min'.is_unit?, true
    assert_equal 'cm /min'.is_unit?, true
    assert_equal 'cm/ min'.is_unit?, true
    assert_equal 'cm / min'.is_unit?, true
  end

  def test_weighted_distance
    assert_equal 'aa'.weighted_distance('aa'), 0
    assert_equal 'aa'.weighted_distance('aaa'), 0.5
    assert_equal 'aa'.weighted_distance('ab'), 1
    assert_equal 'aa'.weighted_distance('aab'), 0.5
    assert_equal 'aa'.weighted_distance('abc'), 1
  end

  def test_remove_punctuation
=begin
    assert_equal 'a-a'.remove_punctuation, 'a-a'
    assert_equal 'a- a'.remove_punctuation, 'a- a'
    assert_equal 'a -a'.remove_punctuation, 'a -a'
    assert_equal 'a - a'.remove_punctuation, 'a  a'
    assert_equal 'a-a - bc'.remove_punctuation, 'a-a  bc'
    assert_equal 'a-a -bc'.remove_punctuation, 'a-a -bc'
=end
    assert_equal 'a.a . 4.3'.remove_punctuation, 'aa  4.3'
    assert_equal '.a....a . 4.334.'.remove_punctuation, 'aa  4.334'
    #assert_equal 'a-a -bc'.remove_punctuation, 'a-a -bc'
  end

  def test_remove_punctuation!

=begin
    a = 'a-a'.remove_punctuation
    assert_equal a, 'a-a'

    b = 'a- a'.remove_punctuation
    assert_equal b, 'a- a'

    c = 'a -a'.remove_punctuation
    assert_equal c, 'a -a'

    d = 'a - a'.remove_punctuation
    assert_equal d, 'a  a'

    e = 'a-a - bc'.remove_punctuation
    assert_equal e, 'a-a  bc'

    f = 'a-a -bc'.remove_punctuation
    assert_equal f, 'a-a -bc'
=end
  end
end