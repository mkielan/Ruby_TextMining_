require 'test/unit'

require_relative '../test/test_text_mining_helper'

include TextMining

class TextMiningTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @source = Attachments::SheetSource.new '../data/EKG_opis.ods'
    @ngram_lrn_src = Attachments::SheetSource.new '../data/EKG_ngrams_lrn.ods'
    @text_mining = TextMining.new @source, @source
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_base
    @text_mining.run
  end
end