require 'gruff'

module TextMining::Helpers
  class ChartDisplay

    def self.display series, title, x_label, y_label, out_name = nil, labels = nil
      if !series.is_a? Hash
        raise 'Excepted object of Hash Class for series'
        return
      end

      g = Gruff::Line.new

      g.title = title

      series.keys.each { |key|
        g.data key, series[key]
      }

      if !labels.nil?
        hash_labels = Hash.new

        (0..labels.length - 1).each { |i|
          hash_labels[i] = labels[i]
        }

        g.labels = hash_labels
      end

      g.write out_name if !out_name.nil?
    end

  end
end
