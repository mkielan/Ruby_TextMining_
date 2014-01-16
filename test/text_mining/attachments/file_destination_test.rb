require 'test/unit'
require '../../test_text_mining_helper'

include TextMining
include TextMining::Attachments

class FileDestinationTest < Test::Unit::TestCase
  prepare_test_results_dir FileDestinationTest

  @@how_many_in_test = 100

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @source = SheetSource.new '../../../data/EKG_opis.ods', header = 1
    @dest_u = FileDestination.new $test_results_dir + '/unigram.txt'
    @dest_d = FileDestination.new $test_results_dir + '/digram.txt'
    @dest_t = FileDestination.new $test_results_dir + '/trigram.txt'

    @unigrams = NGrams.new 1
    @bigrams = NGrams.new 2
    @trigrams = NGrams.new 3

    doc = 1
    while row = @source.next[0]
      puts 'DocumentID: ' + doc.to_s + '/' + @source.count.to_s
      doc += 1

      document = TextMining::Document.new row

      @unigrams.add document
      @bigrams.add document
      @trigrams.add document

      break if doc > @@how_many_in_test
    end
  end

  def test_write_ngram
    puts 'Save Unigrams'
    @dest_u.write @unigrams
    #ChartDisplay.display @unigrams.symbol_freqs, 'unigramy', 'n-gramy', 'częstość'

    puts 'Save Digrams'
    @dest_d.write @bigrams
    #ChartDisplay.display @bigrams.symbol_freqs, 'digramy', 'n-gramy', 'częstość'

    puts 'Save Trigrams'
    @dest_t.write @trigrams
    #ChartDisplay.display @trigrams.symbol_freqs, 'trigramy', 'n-gramy', 'częstość'

    puts 'Finish'
  end
end