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
    d = [1, 2]

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

    assert_equal a.cmp_levenshtein(d), true
    assert_equal a.cmp_levenshtein(b), false
    assert_equal a.cmp_levenshtein(c), true
    assert_equal b.cmp_levenshtein(d), false

    assert_equal ['a'].cmp_levenshtein(['b']), false
    assert_equal ['ab'].cmp_levenshtein(['ba']), false

    assert_equal ['a'].cmp_levenshtein(['a']), true
    assert_equal ['ab'].cmp_levenshtein(['ab']), true
    assert_equal ['dom'].cmp_levenshtein(['domu']), true
    assert_equal ['przebiegly'].cmp_levenshtein(['przebiegla']), true
    assert_equal ['przewiegly'].cmp_levenshtein(['przebiegla']), true
  end

  def test_order_conteining
    a = [1, 2, 3, 4, 5]
    b = [2, 3, 4]

    assert_equal a.order_containing(b), true
    assert_equal a.order_containing([7, 8]), false
    assert_equal a.order_containing([2, 3, 9]), false
    assert_equal a.order_containing([1, 9]), false
  end
end