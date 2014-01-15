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
    while row = @src.next[0]
      puts 'DocumentID: ' + doc.to_s + '/' + @src.count.to_s

      doc += 1
      if row.is_a? String
        document = Document.new row.remove_punctuation!

        @unigrams.add document
        @bigrams.add document
        @trigrams.add document
      end

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

      @dest = FileDestination.new $test_results_dir + "/#{i + 1}-gram_sorted_#{text}.txt"
      @dest.write ngrams_sets[i].freqs

      @dest = FileDestination.new $test_results_dir + "/top_#{i + 1}-gram_#{text}.txt"
      @dest.write ngrams_sets[i].top

      TextMining::Helpers::ChartDisplay.display(
          prepare_series(ngrams_sets[i].freqs),
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

  def prepare_series freqs
    ret = []

    freqs.each { |f|
      ret << f[:freq]
    }

    ret_hash = Hash.new
    ret_hash['n-grams'] = ret
    ret_hash
  end
end