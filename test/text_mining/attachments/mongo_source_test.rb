require 'test/unit'
require '../../test_text_mining_helper'

include TextMining::IO

class MongoSourceTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @client = MongoClient.new
    @source = MongoSource.new @client.db('text_mining').collection('documents'), :body

    doc_id = 0
    while tmp = @source.next
      puts "doc_id: #{doc_id} | #{tmp}"
      doc_id += 1
    end
  end

  def test_fail

  end
end