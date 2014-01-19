require 'test/unit'

require '../../test_text_mining_helper'

include TextMining
include TextMining::IO

class SheetDestinationTest < Test::Unit::TestCase
  prepare_test_results_dir SheetDestinationTest

  @@how_many_in_test = 200

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @source = SheetSource.new '../../../data/EKG_opis.ods', header = 1
    @dest = SheetDestination.new $test_results_dir + '/dest.ods'

    @ngrams_set = []
    3.times { |i| @ngrams_set << NGrams.new(i + 1) }

    doc = 1
    while row = @source.next[0]
      if !row.nil?
        row.remove_punctuation!

        puts 'DocumentID: ' + doc.to_s + '/' + @source.count.to_s

        doc += 1

        @ngrams_set.each { |ngrams| ngrams.add(row) }
      end

      return if doc > @@how_many_in_test
    end
  end

  def test_write_ngram
    3.times { |i|
      @dest.switch_sheet(name = "#{i + 1}-grams")
      puts "Save #{i + 1}-grams"
      @dest.write(@ngrams_set[i])
      @dest.save
    }
  end
end