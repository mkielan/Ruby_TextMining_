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
end