require 'gruff'

# the typical number of histogram bins you want of a large set of data
BIN_NUMBER = 9.0

# class for all roster-related calculations
class Graphs
    attr_reader :roster

    # pass it scraped roster data
    # @param roster
    #   the hash containing all player info
    # @param sport
    #   the string indicating the sport
    # @param search_num
    #   the number appended to the chart output file
    def initialize(roster, sport, search_num)
        @roster = roster
        @sport = sport
        @search_num = search_num
    end

    # make a pie chart of all positions of the given sport.
    def pie_positions  
        # the pos_hash will store counts of each position.
        pos_hash = {}
        @roster.each do |player|
            stats_hash = player[1]
            str = stats_hash[:pos]
            # check if hash already has the key.
            if pos_hash.has_key?(str)
                #increment count of pos.
                pos_hash[str] = pos_hash[str] + 1
            else
                #add key to hash with count 1.
                pos_hash[str] = 1
            end
        end
        # create a new pie chart and set the characteristics.
        g = Gruff::Pie.new
        g.title = "#{@sport} Positions"
        g.show_values_as_labels = 0
        g.text_offset_percentage = 0
        g.hide_labels_less_than = 2
        g.zero_degree = -90
        g.colors = ['#900000', '#ff0000', '#FF7F35', '#EBD04A', '#FFFF00', '#82F300', '#299B00', '#00D098', '#03E0E8', '#009AFF', '#263BFA', '#6932FF', '#AE32FF', '#FF32FF', '#FF92E3', '#B06D7A']
        # add the data to the chart.
        pos_list = pos_hash.keys
        pos_list.each do |unit|
            g.data(unit, pos_hash[unit])
        end
        # output the chart to graphs folder. 
        g.write("graphs/#{@sport}_positions_pie#{@search_num}.png")
        puts 'Made a pie chart!'

    end

    # make a histogram of player weights of current sport
    def histogram_weights
        # get an array of all the weights.
        array_weights = Array.new
        @roster.each do |player|
            hash = player[1]
            wt = hash[:weight]
            array_weights.append(wt.to_i)
        end
        # test the range of data. 
        # a histogram is useless if the range of the data is 0.
        range = array_weights.max - array_weights.min
        if range > 0
            # create a new histogram and set the characteristics.
            g = Gruff::Histogram.new
            g.title = "#{@sport} Player Weights"
            g.colors = ['#BB0000', '#666666']
            g.hide_legend = true
            g.label_formatting = "%d"
            # calculate ideal bin width.
            ideal_bin_width = (range / BIN_NUMBER).ceil
            g.bin_width = ideal_bin_width
            g.y_axis_label = 'Number'
            g.x_axis_label = 'Weight (lbs)'
            g.y_axis_increment = 5
            g.data :A, array_weights
            # output the graph to the graphs folder.
            g.write("graphs/#{@sport}_weights_histogram#{@search_num}.png")
            puts 'Made a histogram!'
        else
            puts 'Unable to make a histogram, the weights data has a range of 0.'
        end
    end

end