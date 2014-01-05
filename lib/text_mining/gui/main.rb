include Java

import java.awt.Dimension
import java.awt.BorderLayout
import javax.swing.JFrame
import javax.swing.JButton
import javax.swing.JPanel
import javax.swing.JScrollPane
import javax.swing.JTextField
import javax.swing.JList
import javax.swing.DefaultListModel

require_relative 'models/document_list_model'

module TextMining::Gui
  class Main < JFrame
    attr_reader :list_model

    def initialize
      super 'TextMining by Mariusz Kielan'

      self.init_ui
    end

    def init_ui
      self.setPreferredSize Dimension.new(450, 500)
      self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
      self.setLocationRelativeTo nil

      self.setLayout BorderLayout.new
      self.add init_search_panel, BorderLayout::NORTH
      self.add init_results_panel, BorderLayout::CENTER

      self.pack
      self.setVisible true
    end

    def init_search_panel
      searchPanel = JPanel.new
      searchPanel.setLayout BorderLayout.new

      search_text = JTextField.new
      search_text.setToolTipText 'Enter the text search of documents...'

      search_button = JButton.new 'Search'
      search_button.setToolTipText 'Click for search documents...'
      search_button.addActionListener ActionListener.new

      searchPanel.add search_text
      searchPanel.add search_button, BorderLayout::EAST

      searchPanel
    end

    def init_results_panel
      @list_model = DefaultListModel.new
      @list_model.addElement Models::DocumentListModel.new('First document...')
      @list_model.addElement 2

      resultsList = JList.new
      resultsList.setModel list_model

      JScrollPane.new resultsList
    end


    class ActionListener
      include java.awt.event.ActionListener

      def actionPerformed evt
        javax.swing.JOptionPane.showMessageDialog(nil, <<EOS)
<html>Hello from <b><u>JRuby</u></b>.<br>
EOS
      end
    end
  end
end