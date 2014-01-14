require 'gruff'

module TextMining::Helpers
  class ChartDisplay

    def self.display series, title, x_label, y_label, out_name = nil, labels = nil
      if !series.is_a? Hash
        raise 'Excepted object of Hash Class for series'
        return
      end

      g = Gruff::Line.new
      g.theme = {
          :colors => %w(black grey),
          :marker_color => 'grey',
          :font_color => 'black',
          :background_colors => 'white'
      }
      g.title = title

      series.keys.each { |key|
        g.data key, series[key]
      }


      hash_labels = Hash.new
      if !labels.nil?
        (0..labels.length - 1).each { |i|
          hash_labels[i] = labels[i]
        }
      else
        if series.length < 10
          delta = 1
        elsif series.length < 100
          delta = 20
        elsif series.length < 500
          delta = 50
        else
          delta = 100
        end

        series[series.keys[0]].length.times { |i|
          hash_labels[i] = i % delta == 0 ? i.to_s : ''
        }
      end
      g.labels = hash_labels

      g.write out_name if !out_name.nil?
    end

  end
end
