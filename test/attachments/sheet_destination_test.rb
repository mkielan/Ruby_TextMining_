require 'test/unit'

require '../test_text_mining_helper'

include TextMining::Tools
include TextMining::Attachments

class SheetDestinationTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @source = SheetSource.new '../../data/EKG_opis.ods', header = 1
    @dest = SheetDestination.new '../../data/dest.ods'

    @unigrams = NGram.new 1
    @bigrams = NGram.new 2
    @trigrams = NGram.new 3

    doc = 1
    while row = @source.next[0].remove_punctuation!
      puts 'DocumentID: ' + doc.to_s + '/' + @source.count.to_s

      doc += 1
      @unigrams.add row
      @bigrams.add row
      @trigrams.add row

      return if doc > 200
    end
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_write_ngram
    @dest.switch_sheet(name = 'unigram')
    puts 'Save Unigram'
    @dest.write(@unigrams)

    @dest.switch_sheet(name = 'digram')
    puts 'Save Digram'
    @dest.write(@bigrams)

    @dest.switch_sheet(name = 'trigram')
    puts 'Save Trigram'
    @dest.write(@trigrams)
  end
end