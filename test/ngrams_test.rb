require 'test/unit'

require '../test/test_text_mining_helper'

include TextMining
include TextMining::Attachments

class NGramsTest < Test::Unit::TestCase
  prepare_test_results_dir NGramsTest

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

      return if doc > 100
    end
  end

  def test_general
    @dest = FileDestination.new $test_results_dir + '/top1.txt'
    @dest.write @unigrams.top

    @dest = FileDestination.new $test_results_dir + '/top2.txt'
    @dest.write @bigrams.top

    @dest = FileDestination.new $test_results_dir + '/top3.txt'
    @dest.write @trigrams.top


    puts 'reduce test'
    @dest = FileDestination.new $test_results_dir + '/top2_after_reduce_with3.txt'

    @bigrams.reduce_containing! @trigrams
    @dest.write @bigrams.top
  end
end