require 'test/unit'

require_relative '../../test/test_text_mining_helper'

include TextMining

class TextMiningTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @mongo_client = MongoClient.new
    @collection = @mongo_client.db('text_mining').collection('documents')
    @source = IO::MongoSource.new @collection, :body

    @text_mining = TextMining::TextMining.new @source
  end

  def test_base
    puts @text_mining.n_grams_manager.sequences.length
  end
end