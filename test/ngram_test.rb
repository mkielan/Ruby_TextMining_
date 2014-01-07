require 'test/unit'

require '../test/test_text_mining_helper'

include TextMining

class NGramTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @bigrams = [
        NGram.new(['test', 'one']),
        NGram.new(['one', 'two']),
        NGram.new(['two', 'tree']),
        NGram.new(['tree', 'test'])
    ]
  end

  # Fake test
  def test_equal
    @bigrams.length.times { |i|
      assert_equal (@bigrams[i] == @bigrams[i]), true
    }

    assert_equal (@bigrams[0] == NGram.new(['test', 'one'])), true
  end

  def test_not_equal
    @bigrams.length.times { |i|
      @bigrams.length.times { |j|
        result = @bigrams[i] == @bigrams[j]
        puts "#{@bigrams[i]} and #{@bigrams[j]} = #{result}"

        if i != j
          assert_equal result, false
        else
          assert_equal result, true
        end
      }
    }
  end
end