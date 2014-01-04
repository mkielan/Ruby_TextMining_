require 'test/unit'

require_relative '../../test/test_text_mining_helper'

include TextMining::Gui
include TextMining::Gui::Models

class DocumentViewTest < Test::Unit::TestCase

  def setup
    @doc = DocumentModel.new
    @doc.title= 'Test Document'
    @doc.text= 'Test Document Body.'
  end

  # Fake test
  def test_viewer
    @viewer = DocumentView.new @doc

    while true
      sleep 1
    end
  end
end