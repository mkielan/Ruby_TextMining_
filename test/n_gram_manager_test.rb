require 'test/unit'

require_relative '../test/test_text_mining_helper'

include TextMining

class NGramManagerTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @manager = TextMining::NGramsManager.new
    @src = TextMining::Attachments::SheetSource.new '../data/EKG_opis.ods', header = 1

    doc_id = 1
    while doc = @src.next[0].remove_punctuation!
      puts 'DocumentID: ' + doc_id.to_s + '/' + @src.count.to_s

      doc_id += 1
      document = Document.new doc

      @manager.add document

      return if doc_id > 20
    end
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    # Do nothing
  end

  def test_reduce
    @manager.reduce
    puts 'Finish'
  end
end