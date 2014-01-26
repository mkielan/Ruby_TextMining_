#require 'test/unit'

require_relative '../../test/test_text_mining_helper'

include TextMining
include TextMining::IO

class DocumentComparerTest #< Test::Unit::TestCase
  @@how_many_in_test = 250
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @compare_count = 200

    prepare_test_results_dir DocumentComparerTest

    @documents = []
    @manager = NGramsManager.new
    @comparer = DocumentComparer.new @manager

    #@src = SheetSource.new '../../data/EKG_opis.ods', header = 1

    @mongo_client = MongoClient.new
    @collection = @mongo_client.db('text_mining').collection('documents')
    @src = IO::MongoSource.new @collection, :body

    doc_id = 1
    while doc_id < @src.count - 1 and doc_id < @@how_many_in_test
      begin
        doc = @src.next
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

        @manager.add document
      rescue
      end

      doc_id += 1
    end
  end

  # compare and save table
  def test_compare_many
    result = @comparer.compare @first_doc, @second_doc

    #assert_equal result >= 0, true
    #assert_equal result <= 1, true

    results = Array.new(@documents.length) { Array.new(@documents.length, 0) }

    @dest = SheetDestination.new $test_results_dir + "/loaded(#{@doc_count})_compare-documents(#{@compare_count}).ods"

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
    dest = SheetDestination.new $test_results_dir + '/tdm.ods'
    dest.write_tdm @documents

  end

  def find_ngrams docs, doc_in_groups, top_ngrams, groups_count
    ret = Array.new(groups_count) { Array.new(top_ngrams.length, 0) }

    docs.each_index { |d_index|
      gr = doc_in_groups[d_index]
      if !doc.nil? and !docs[d_index].vector.nil?
        docs[d_index].vector.each_index { |v|
          ret[gr][v] += docs[d_index].vector[v]
        }
      end
    }

    h = Array.new(groups_count) {Array.new}

    ret.length.times { |i|
      ret[i].length.times { |j|
        h[i] << Hash[:symbol, top_ngrams[j],:freq, ret[i][j]]
      }

      h[i].sort! { |a, b| b[:freq] <=> a[:freq] }
    }
    h
  end
end


d = DocumentComparerTest.new
d.setup
d.test_compare_many