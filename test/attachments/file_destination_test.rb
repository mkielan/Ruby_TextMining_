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

    @unigram = NGram.new 1
    @digram = NGram.new 2
    @trigram = NGram.new 3

    doc = 1
    while row = @source.next[0]
      puts 'DocumentID: ' + doc.to_s + '/' + @source.count.to_s
      doc += 1

      document = TextMining::Document.new row

      @unigram.add document
      @digram.add document
      @trigram.add document

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
    @dest_u.write @unigram
    #ChartDisplay.display @unigram.symbol_freqs, 'unigramy', 'n-gramy', 'częstość'

    puts 'Save Digram'
    @dest_d.write @digram
    #ChartDisplay.display @digram.symbol_freqs, 'digramy', 'n-gramy', 'częstość'

    puts 'Save Trigram'
    @dest_t.write @trigram
    ChartDisplay.display @trigram.symbol_freqs, 'trigramy', 'n-gramy', 'częstość'

    puts 'Finish'

    #STDIN.readline
  end
end