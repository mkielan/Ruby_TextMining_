require 'test/unit'

require '../test/test_text_mining_helper'

include TextMining
include TextMining::Attachments



class NGramsTest < Test::Unit::TestCase
  prepare_test_results_dir NGramsTest

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @unigrams = NGrams.new 1
    @bigrams = NGrams.new 2
    @trigrams = NGrams.new 3

    @src = SheetSource.new '../data/EKG_opis.ods', header = 1

    doc = 1
    while row = @src.next[0].remove_punctuation!
      puts 'DocumentID: ' + doc.to_s + '/' + @src.count.to_s

      doc += 1
      document = Document.new row

      @unigrams.add document
      @bigrams.add document
      @trigrams.add document

      return if doc > 200
    end
  end

  def test_general
    _test_freqs
    _test_reduce_containing
  end

  def _test_freqs
    @dest = FileDestination.new $test_results_dir + '/top1.txt'
    @dest.write @unigrams.top

    @dest = FileDestination.new $test_results_dir + '/top2.txt'
    @dest.write @bigrams.top

    @dest = FileDestination.new $test_results_dir + '/top3.txt'
    @dest.write @trigrams.top
  end

  def _test_reduce_containing
    @trigrams.reduce_containing! @bigrams

    @dest = FileDestination.new $test_results_dir + '/top3_after_reduce.txt'
    @dest.write @trigrams.top
  end
end