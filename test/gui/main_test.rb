require 'test/unit'

require_relative '../../test/test_text_mining_helper'

include TextMining::Gui

class MainTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @main = Main.new
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_run
    while true

    end
  end
end