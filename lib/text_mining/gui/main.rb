include Java

import javax.swing.JFrame
import javax.swing.JButton

module TextMining::Gui
  class Main < JFrame
    def initialize
      super "TextMining by Mariusz Kielan"

      self.initUI
    end

    def initUI
      self.setSize 300, 200
      self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
      self.setLocationRelativeTo nil

      button = JButton.new 'Button'
      self.add button

      self.setVisible true
    end
  end
end