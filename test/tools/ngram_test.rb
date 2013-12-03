require 'test/unit'

require '../test_text_mining_helper'

include TextMining::Tools

class NGramTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @unigram = NGram.new 1
    @digram = NGram.new 2
    @trigram = NGram.new 3

    @src = TextMining::Attachments::SheetSource.new '../../data/EKG_opis.ods', header = 1

    doc = 1
    while row = @src.next[0].remove_punctuation!
      puts 'DocumentID: ' + doc.to_s + '/' + @src.count.to_s

      doc += 1
      document = TextMining::Document.new row

      @unigram.add document
      @digram.add document
      @trigram.add document

      return if doc > 200
    end
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_freqs
    @dest = TextMining::Attachments::FileDestination.new 'top1.txt'
    @dest.write @unigram.top

    @dest = TextMining::Attachments::FileDestination.new 'top2.txt'
    @dest.write @digram.top

    @dest = TextMining::Attachments::FileDestination.new 'top3.txt'
    @dest.write @trigram.top
  end
end