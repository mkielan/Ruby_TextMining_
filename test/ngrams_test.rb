# encoding: utf-8

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
    ngrams_sets = [@unigrams, @bigrams, @trigrams]

    print_results ngrams_sets


    puts 'reduce test'
    @unigrams.reduce_containing! @bigrams
    @bigrams.reduce_containing! @trigrams

    print_results ngrams_sets, 'reduce'

    @dest = FileDestination.new $test_results_dir + '/top2_after_reduce_with3.txt'


    @dest.write @bigrams.top
  end

  def print_results ngrams_sets, text = ''
    ngrams_sets.each_index { |i|
      @dest = FileDestination.new $test_results_dir + "/#{i + 1}-gram_#{text}.txt"
      @dest.write ngrams_sets[i]

      @dest = FileDestination.new $test_results_dir + "/top_#{i + 1}-gram_#{text}.txt"
      @dest.write ngrams_sets[i].top

      TextMining::Helpers::ChartDisplay.display(
          prepare_series(ngrams_sets[i]),
          "Częstości #{i + 1}-gramów w modelu",
          "#{i + 1}-gramy",
          'częstość',
          $test_results_dir + "/#{i + 1}-gram_#{text}_chart.png")

      TextMining::Helpers::ChartDisplay.display(
          prepare_series(ngrams_sets[i].top),
          "Częstości #{i + 1}-gramów w modelu",
          "#{i + 1}-gramy",
          'częstość',
          $test_results_dir + "/top_#{i + 1}-gram_#{text}_chart.png")
    }
  end

  def prepare_series hash
    ret_hash = Hash.new

    hash.keys { |key|
      ret_hash[key] = hash[key]
    }

    ret_hash
  end
end