require 'test/unit'

require_relative '../test/test_text_mining_helper'

include TextMining

class SequenceTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @bigrams = [['test', 'one'], ['one', 'two'], ['two', 'tree'], ['tree', 'test']]
    @bigrams_support = [0.45, 0.50, 0.80, 0.78]
  end

  def test_add
    seq = Sequence.new

    seq.add @bigrams[1]
    assert_equal seq.elements[0], @bigrams[1]

    seq.add @bigrams[0]
    assert_equal seq.elements[0], @bigrams[0]
  end

  def test_add_to_front
    seq = Sequence.new

    (0..@bigrams.length - 1).each { |i|
      seq.add_to_front @bigrams[i]
      assert_equal seq.elements[0], @bigrams[i]
    }
  end

  def test_add_to_end
    seq = Sequence.new

    (0..@bigrams.length - 1).each { |i|
      seq.add_to_end @bigrams[i]
      assert_equal seq.elements[i], @bigrams[i]
    }
  end

  def test_contain
    seq = Sequence.new

    (0..@bigrams.length - 1).each { |i|
      seq.add @bigrams[i]

      (0..i - 1).each { |t|
        assert_equal seq.contain(@bigrams[t]), true

        tmp = @bigrams[0, t + 1]
        assert_equal seq.contain(tmp), true
      }

      (i + 1..@bigrams.length - 1).each { |k|
        assert_equal seq.contain(@bigrams[k]), false
      }
    }
  end

  def test_support
    seq = Sequence.new

    sum = 0
    @bigrams.length.times { |i|
      seq.add_to_front @bigrams[i], @bigrams_support[i]
      sum += @bigrams_support[i]

      assert_equal seq.support, sum / (i + 1)
    }
  end

  def test_starts_from
    seq = Sequence.new

    (0..@bigrams.length - 2).each { |i|
      seq.add_to_front @bigrams[i]

      assert_equal seq.starts_from(@bigrams[i]), true
      assert_equal seq.length, i + 1
    }

    seq = Sequence.new

    (0..@bigrams.length - 2).each { |i|
      seq.add_to_end @bigrams[i]

      assert_equal seq.starts_from(@bigrams[0]), true
      assert_equal seq.length, i + 1
    }
  end

  def test_ends_at
    seq = Sequence.new

    (0..@bigrams.length - 2).each { |i|
      seq.add_to_end @bigrams[i]

      assert_equal seq.ends_at(@bigrams[i]), true
      assert_equal seq.length, i + 1
    }

    seq = Sequence.new

    (0..@bigrams.length - 2).each { |i|
      seq.add_to_front @bigrams[i]

      assert_equal seq.ends_at(@bigrams[0]), true
      assert_equal seq.length, i + 1
    }
  end

  def test_length
    seq = Sequence.new

    seq.add_to_front @bigrams[0]
    assert_equal seq.length, 1

    seq.add_to_end @bigrams[1]
    assert_equal seq.length, 2

    seq.add @bigrams[2]
    assert_equal seq.length, 3
  end
end