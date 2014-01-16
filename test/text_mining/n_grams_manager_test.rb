require 'test/unit'

require_relative '../../test/test_text_mining_helper'

include TextMining

class NGramsManagerTest < Test::Unit::TestCase
  prepare_test_results_dir NGramsManagerTest

  @@how_main_in_test = 100

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    prepare_test_results_dir NGramsManagerTest

    @manager = NGramsManager.new
    @src = Attachments::SheetSource.new '../../data/EKG_opis.ods', header = 1

    doc_id = 1
    while doc = @src.next[0].remove_punctuation!
      puts 'DocumentID: ' + doc_id.to_s + '/' + @src.count.to_s

      document = Document.new doc
      @first_doc = document if doc_id == 1
      @manager.add document

      doc_id += 1
      break if doc_id > @@how_main_in_test
    end
  end

  def test_reduce

  end
end