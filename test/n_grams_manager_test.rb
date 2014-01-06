require 'test/unit'

require_relative '../test/test_text_mining_helper'

include TextMining

class NGramsManagerTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    prepare_test_results_dir NGramsManagerTest

    @manager = NGramsManager.new
    @manager.auto_find_sequence = false
    @src = Attachments::SheetSource.new '../data/EKG_opis.ods', header = 1

    doc_id = 1
    while doc = @src.next[0].remove_punctuation!
      puts 'DocumentID: ' + doc_id.to_s + '/' + @src.count.to_s

      document = Document.new doc
      @first_doc = document if doc_id == 1
      @manager.add document

      doc_id += 1
      return if doc_id > 20
    end

    #@manager.find_sequences
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    # Do nothing
  end

  def test_reduce
    @manager.find_sequences
    sequences = @manager.find_sequences_for @first_doc
    puts sequences.to_s
    puts 'Finish'
  end
end