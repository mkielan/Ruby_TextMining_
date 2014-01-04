include Java

import java.awt.Dimension
import java.awt.BorderLayout
import javax.swing.JFrame
import javax.swing.JButton
import javax.swing.JPanel
import javax.swing.JScrollPane
import javax.swing.JTextArea

module TextMining::Gui
  class DocumentView < JFrame
    attr_reader :document
    attr_reader :parent

    def initialize model, parent = nil
      super 'Document View'

      self.init_ui

      self.document= model if model.is_a? Models::DocumentModel
      @parent = parent

      self.setVisible true
    end

    def init_ui
      self.setPreferredSize Dimension.new(450, 500)
      #self.setMinimumSize Dimension.new(200, 200)
      self.setDefaultCloseOperation JFrame::HIDE_ON_CLOSE
      self.setLocationRelativeTo @parent

      @textArea = JTextArea.new
      @textArea.setEditable false

      scrollPane = JScrollPane.new @textArea
      self.add scrollPane

      self.pack
    end

    def document=(object)
      if object.is_a? Models::DocumentModel
        @document = object

        self.setTitle 'Document View - ' + @document.title.to_s
        @textArea.setText @document.text
      end
    end
  end
end