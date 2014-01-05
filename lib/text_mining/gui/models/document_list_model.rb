
module TextMining::Gui
  module Models
    class DocumentListModel
      attr_accessor :short_text

      def initialize short_text = nil
        @short_text = short_text if !short_text.nil?
      end

      def to_s
        @short_text
      end
    end
  end
end
