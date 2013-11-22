require 'test/unit'

require_relative '../test/test_text_mining_helper'

include TextMining

class ArrayTest < Test::Unit::TestCase

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

  def test_compare
    a = [1, 2, 3, 3]
    b = [1, 2, 3, 3]
    c = [2, 1, 4, 5]

    d = [1,2]

    assert_equal a.compare(b), true
    assert_equal a.compare(c), false
    assert_equal b.compare(c), false
    assert_equal a.compare(d), false
    assert_equal b.compare(c), false
    assert_equal d.compare(c), false
    assert_equal a.compare(a), true
  end

  def test_cmp_levenstein
    a = ['ale', 'po co', 'test', 'dom', 'deko']
    b = ['ale', 'po co to', 'testem', 'domu', 'deko']
    c = ['ala', 'po co', 'dest', 'doma', 'deko']
    d = ['ale', 'po co', 'test', 'dom', 'deko']

    assert_equal a.cmp_levenshtein(d), [0, 0, 0, 0, 0]
    assert_equal a.cmp_levenshtein(b), [0, 3, 2, 1, 0]
    assert_equal a.cmp_levenshtein(c), [1, 0, 1, 1, 0]
    assert_equal b.cmp_levenshtein(d), [0, 3, 2, 1, 0]
  end
end