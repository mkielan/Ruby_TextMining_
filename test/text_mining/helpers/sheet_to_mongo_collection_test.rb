require 'test/unit'
require '../../test_text_mining_helper'
require 'mongo'

include TextMining::Helpers
include TextMining::Attachments

class SheetToMongoCollectionTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @source = SheetSource.new '../../../data/EKG_opis.ods', header = 1

    @attr = [:body, :describe]

    @doc_col = MongoClient.new().db('text_mining').collection('documents')
    @doc_col.remove
  end

  # Fake test
  def test_do
    assert_equal @doc_col.count, 0

    SheetToMongoCollection.do @source, @doc_col, @attr

    assert_equal @source.count, @doc_col.count
  end
end