require 'test/unit'

require '../test_text_mining_helper'

include TextMining::Tools

class NGramTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @ngram = NGram.new 2

    @src = TextMining::Attachments::SheetSource.new '../../data/EKG_opis.ods'

    x = 1
    while row = @src.next
      puts x
      x += 1
      @ngram.add row[0]

      break if x > 50
    end
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_freqs
    top = @ngram.freqs #[0, 60]

    @dest = TextMining::Attachments::FileDestination.new 'top.txt'
    @dest.write top
  end
end