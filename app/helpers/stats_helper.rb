module StatsHelper
    def barchart_height(num_bars)
        [num_bars * 30 + 100, 200].max
    end

    def default_colors
        ["#ff002a", "#ef9d0e", "#f3f61e", "#13ae10", "#27a7f1", "#4d27ef", "#cf12f8"]
    end

    def darken_color(hex_color, amount=0.4)
        hex_color = hex_color.gsub('#','')
        rgb = hex_color.scan(/../).map {|color| color.hex}
        rgb[0] = (rgb[0].to_i * amount).round
        rgb[1] = (rgb[1].to_i * amount).round
        rgb[2] = (rgb[2].to_i * amount).round
        "#%02x%02x%02x" % rgb
      end
    
    def line_colors(n_lines)
        cycle = default_colors()
        (0..n_lines).map {|i| darken_color(cycle[i % cycle.length()], 2.0 / (2 + i / cycle.length()).to_f)}
    end
end
