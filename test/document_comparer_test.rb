require 'test/unit'

require_relative '../test/test_text_mining_helper'

include TextMining

class DocumentComparerTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    #prepare_test_results_dir DocumentComparerTest

    @manager = NGramsManager.new
    @comparer = DocumentComparer.new @manager

    @manager.auto_find_sequence = false
    @src = Attachments::SheetSource.new '../data/EKG_opis.ods', header = 1

    doc_id = 1
    while doc = @src.next[0].remove_punctuation!
      puts 'DocumentID: ' + doc_id.to_s + '/' + @src.count.to_s

      document = Document.new doc
      @first_doc = document if doc_id == 1
      @second_doc = document if doc_id == 2

      @manager.add document

      doc_id += 1
      break if doc_id > 20
    end

    @manager.find_sequences
  end

  # Fake test
  def test_comapre
    result = @comparer.compare @first_doc, @second_doc
    puts "result:#{result} of compare #{@first_doc} and #{@second_docc}"
    assert_equal result >= 0, true
    assert_equal result <= 1, true
  end
end