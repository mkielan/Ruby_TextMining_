require 'test/unit'
require '../../test_text_mining_helper'

include TextMining::Helpers

class CosinusDistanceTest < Test::Unit::TestCase


  def test_compare
    puts CosinusDistance.similarity([1,2,3], [1,2,0])
    assert_equal CosinusDistance.similarity([1,2,3], [1,2,3]), 1
    assert_not_equal CosinusDistance.similarity([1,2,3], [1,2,3]), 0
    assert_equal CosinusDistance.similarity([1,2,3], [5,2,4]), 0.8366600265340755
  end

  def test_euclides
    assert_equal CosinusDistance.euclides([1,1,1,1]), 4
    assert_equal CosinusDistance.euclides([]), 0
    assert_raise(ArgumentError) { CosinusDistance.euclides(1) }
    assert_raise(ArgumentError) { CosinusDistance.euclides('as') }
  end
end