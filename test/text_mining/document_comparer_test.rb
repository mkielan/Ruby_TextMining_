require 'test/unit'

require_relative '../../test/test_text_mining_helper'

include TextMining

class DocumentComparerTest < Test::Unit::TestCase
  @@how_many_in_test = 30
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @compare_count = 20

    prepare_test_results_dir DocumentComparerTest

    @documents = []
    @manager = NGramsManager.new
    @comparer = DocumentComparer.new @manager

    @src = TextMining::IO::SheetSource.new '../../data/EKG_opis.ods', header = 1

    doc_id = 1
    while doc_id < @src.count - 1 and doc_id < @@how_many_in_test
      begin
        doc = @src.next[0]
        puts 'DocumentID: ' + doc_id.to_s + '/' + @src.count.to_s if doc_id % 10 == 0

        if doc.nil?
          puts 'Empty document!'
          next
        else
          document = Document.new doc
        end

        @documents << document
        @first_doc = document if doc_id == 1
        @second_doc = document if doc_id == 2
        if doc_id == 998
          puts 1
        end
        @manager.add document
      rescue
      end

      doc_id += 1
    end
  end

  # compare and save table
  def test_compare_many
    result = @comparer.compare @first_doc, @second_doc

    assert_equal result >= 0, true
    assert_equal result <= 1, true

    results = Array.new(@documents.length) { Array.new(@documents.length, 0) }

    @dest = TextMining::IO::SheetDestination.new $test_results_dir + "/loaded(#{@doc_count})_compare-documents(#{@compare_count}).ods"

    @documents.length.times { |i|
      @documents.length.times { |j|
        puts "comapre #{i} with #{j}" if j % 10 == 0

        results[i][j] = @comparer.compare @documents[i], @documents[j]

        @dest.write results[i][j], i, j

        break if j + 1 >= @compare_count
      }

      break if i + 1 >= @compare_count
    }

    @dest.save
  end
end