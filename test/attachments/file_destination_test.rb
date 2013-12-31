require 'test/unit'
require '../test_text_mining_helper'

include TextMining::Tools
include TextMining::Attachments

class FileDestinationTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @source = SheetSource.new '../../data/EKG_opis.ods', header = 1
    @dest_u = FileDestination.new 'unigram.txt'
    @dest_d = FileDestination.new 'digram.txt'
    @dest_t = FileDestination.new 'trigram.txt'

    @unigrams = NGram.new 1
    @bigrams = NGram.new 2
    @trigrams = NGram.new 3

    doc = 1
    while row = @source.next[0]
      puts 'DocumentID: ' + doc.to_s + '/' + @source.count.to_s
      doc += 1

      document = TextMining::Document.new row

      @unigrams.add document
      @bigrams.add document
      @trigrams.add document

      #@unigram.add document.body
      #@digram.add document.body
      #@trigram.add document.body

      return if doc > 100
    end
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_write_ngram
    puts 'Save Unigram'
    @dest_u.write @unigrams
    ChartDisplay.display @unigrams.symbol_freqs, 'unigramy', 'n-gramy', 'częstość'

    puts 'Save Digram'
    @dest_d.write @bigrams
    ChartDisplay.display @bigrams.symbol_freqs, 'digramy', 'n-gramy', 'częstość'

    puts 'Save Trigram'
    @dest_t.write @trigrams
    ChartDisplay.display @trigrams.symbol_freqs, 'trigramy', 'n-gramy', 'częstość'

    puts 'Finish'

    STDIN.readline
  end
end