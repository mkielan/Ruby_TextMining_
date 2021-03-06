require 'test/unit'
require '../../test_text_mining_helper'

class ChartDisplayTest < Test::Unit::TestCase
  prepare_test_results_dir ChartDisplayTest

  def setup
    @out_filename = $test_results_dir + '/out.png'
    @test_hash = { :Seria => [1, 2, 3, 4, 5] }
    @test_title = 'test title'
    @test_x_label = 'test_x'
    @test_y_label = 'test_y'

    File.delete @out_filename if File.exist? @out_filename
  end

  def test_save_chart
    puts 'Create and save chart'

    TextMining::Helpers::ChartDisplay.display(
        @test_hash,
        @test_title,
        @test_x_label,
        @test_y_label)

    assert_equal File.exist?(@out_filename), false

    TextMining::Helpers::ChartDisplay.display(
        @test_hash,
        @test_title,
        @test_x_label,
        @test_y_label,
        @out_filename)

    assert_equal File.exist?(@out_filename), true
  end
end