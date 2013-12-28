require 'test/unit'
require '../test_text_mining_helper'

class ChartDisplayTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @out_filename = 'out.png'
    @test_hash = {:Seria => [1, 2, 3, 4, 5]}
    @test_title = 'test title'
    @test_x_label = 'test_x'
    @test_y_label = 'test_y'

    File.delete @out_filename if File.exist? @out_filename
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
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