require 'test/unit'

require '../test_text_mining_helper'

include TextMining::Tools

class NGramTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup

    @ngram = NGram.new 1

    @src = TextMining::Attachments::SheetSource.new '../../data/EKG_opis.ods'

    while row = @src.next
      @ngram.add row[0]
    end

    puts 'finish'
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_fail
  end
end