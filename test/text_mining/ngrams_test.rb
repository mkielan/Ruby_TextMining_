# encoding: utf-8

require 'test/unit'

require '../../test/test_text_mining_helper'

include TextMining
include TextMining::IO

class NGramsTest < Test::Unit::TestCase

  def setup

  end

  def test_with_levenshten
    prepare_test_results_dir(NGramsTest.to_s + ' with Levenshtein')
    prepare true

    self.do
  end

  def test_without_levenshtein
    prepare_test_results_dir(NGramsTest.to_s + ' without Levenshtein')
    prepare false

    self.do
  end

  def prepare levenshtein = true
    @ngrams_sets = []
    3.times { |i|
      ngrams = NGrams.new(i+1)
      ngrams.use_levenshtein = levenshtein
      @ngrams_sets << ngrams
    }

    @mongo_client = MongoClient.new
    @collection = @mongo_client.db('text_mining').collection('documents')
    @src = IO::MongoSource.new @collection, :body

    #@src = SheetSource.new '../../data/EKG_opis.ods', header = 1

    doc = 1
    while row = @src.next
      if !row.nil?
        puts 'DocumentID: ' + doc.to_s + '/' + @src.count.to_s

        doc += 1
        if row.is_a? String
          document = Document.new row.remove_punctuation!

          @ngrams_sets.each {|e| e.add document }
        end

        break if doc > 100
      end
    end
  end

  def do
    print_results @ngrams_sets

    puts 'reduce test'
    @ngrams_sets[0].reduce_containing! @ngrams_sets[1]
    @ngrams_sets[1].reduce_containing! @ngrams_sets[2]

    print_results @ngrams_sets, 'reduce'

    @dest = FileDestination.new $test_results_dir + '/top2_after_reduce_with3.txt'
    @dest.write @ngrams_sets[2].top
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