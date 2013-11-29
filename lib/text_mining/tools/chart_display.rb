require 'rinruby'

module TextMining::Tools
  class ChartDisplay

    def self.display vector, title, xlab, ylab
      R.vector = vector
      R.title = title
      R.x_lab = xlab
      R.y_lab = ylab

      R.eval <<EOF
        sorted = sort(vector, decreasing = TRUE)
        plot(sorted, xlab = x_lab, ylab = y_lab, main = title)
EOF
    end
  end
end
