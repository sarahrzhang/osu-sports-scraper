require 'mechanize'
require 'nokogiri'
require 'gruff'
require_relative './roster_scraper'

# define constants
MIN_UNSIGNED_INTEGER = 0
MAX_UNSIGNED_INTEGER = 4294967295
INCHES_PER_FOOT = 12.0

class RosterStats
    attr_reader :roster, :sport
    
    # initialize variables to store all scraped data
    #
    # @param roster 
    #    the hash that stores our data
    # @param sport
    #   the string that specifies the sport scraped
    def initialize(roster, sport)
        @roster = roster
        @sport = sport
    end
    
    # gets the number of elements that meet a certain requirement
    #
    # @param key
    #   the attribute of the players to count
    def get_attribute_count(key)
        hash = {}
        @roster.each do |player|
            stats_hash = player[1]
            str = stats_hash[key].strip
            
            if hash.has_key?(str)
                #increment count of pos.
                hash[str] = hash[str] + 1
            else
                #add key to hash with count 1.
                hash[str] = 1
            end
        end
        list = hash.keys
        list.sort!
        puts ''
        list.each do |unit|
            puts "#{unit}: #{hash[unit]}"
        end
        sleep(2)
    end

    # searches sports rosters by name, height, weight, position, year, hometown
    #
    # outputs the search results
    def search_roster
        # obtain search criteria from user
        puts "\nPlease enter the criteria you would like to search for in each field, followed by ENTER"
        puts 'If you do not wish to specify some search criteria, just press ENTER.'
        print 'First Name: '
        fname = gets.chomp
        print 'Last Name: '
        lname = gets.chomp
        print 'Height (ft-in): '
        height = gets.chomp
        print 'Weight: '
        weight = gets.chomp.to_i
        print 'Year: '
        year = gets.chomp
        print 'Position: '
        pos = gets.chomp
        print 'City: '
        city = gets.chomp

        # create copy of roster for search purposes
        roster_copy = @roster
        # perform consecutive searches on the same hash to isolate players that fit all criteria
        unless fname.empty?
            search_criteria(fname, :first, roster_copy)
        end
        unless lname.empty?
            search_criteria(lname, :last, roster_copy)
        end
        unless height.empty?
            search_criteria(height, :height, roster_copy)
        end
        unless weight.zero?
            search_criteria(weight, :weight, roster_copy)
        end
        unless year.empty?
            search_criteria(year, :year, roster_copy)
        end
        unless pos.empty?
            search_criteria(pos, :pos, roster_copy)
        end
        unless city.empty?
            search_criteria(city, :city, roster_copy)
        end

        # output all players that match criteria
        search_output(roster_copy)

        # search with no results
        if roster_copy.empty?
            puts "\n* NO RESULTS FOUND *\n"
        end
        
        # pause briefly to display results
        sleep(3)
    end

    # determine which players fit the input search criteria
    #
    # @param input
    #   the search criteria from the user
    # @param key
    #   the symbol for the search criteria that corresponds to input
    # @param roster
    #   the hash for the roster data
    def search_criteria(input, key, roster)
        roster.each do |player|
            hash = player[1]
            # if the search criteria is not found, remove the player from the hash
            unless hash[key].to_s.casecmp(input.to_s).zero? 
                original_key = player[0]
                roster.delete(original_key)
            end
        end
    end

    # calculates the max, min and avg height for some roster
    #
    # outputs the calculated results
    def heights
        total = 0
        shortest = 'No one'
        tallest = 'No one'
        min = MAX_UNSIGNED_INTEGER
        max = MIN_UNSIGNED_INTEGER
        # identify the tallest and shortest heights and corresponding players
        @roster.each do |player|
            hash = player[1]
            ht = hash[:height]
            ft_in = ht.split('-')
            p_height = INCHES_PER_FOOT * ft_in[0].to_i + ft_in[1].to_i
            # keep track of max and min
            if p_height > max
                max = p_height
                tallest = player
            end
            if p_height < min
                min = p_height
                shortest = player
            end
            # keep sum of all heights for avg
            total += p_height
        end
        
        # output the average, shortest player, and tallest player
        if @roster.length > 0
            avg = total.to_f / @roster.length
            puts ''
            print 'Average Height: '
            print_height(avg)
            puts ''
            print 'Shortest Player: '
            print_height(min)
            puts " (#{shortest[0]})"
            print 'Tallest Player: '
            print_height(max)
            puts " (#{tallest[0]})"
        end
    end

    # outputs player height
    #
    # @param height
    #   the height of a player
    def print_height(height)
        feet = (height/INCHES_PER_FOOT).truncate
        inches = height.remainder(INCHES_PER_FOOT).round(2)
        print "#{feet}\'#{inches}\""
    end


    # outputs player weight
    #
    # @param weight
    #   the weight of a player
    def weights
        total = 0
        lightest = 'No one'
        heaviest = 'No one'
        min = MAX_UNSIGNED_INTEGER
        max = MIN_UNSIGNED_INTEGER
        # find the heaviest, lightest, and total weights
        @roster.each do |player|
            hash = player[1]
            wt = hash[:weight].to_i
            if wt > max
                max = wt
                heaviest = player
            end
            if wt < min
                min = wt
                lightest = player
            end
            total += wt
        end
        # output the average, lightest, and heaviest weights of players
        if @roster.length > 0
            avg = total.to_f / @roster.length
            puts ''
            puts "Average Weight: #{avg.round(2)} lbs"
            puts "Lightest Weight: #{min} lbs (#{lightest[0]})"
            puts "Heaviest Weight: #{max} lbs (#{heaviest[0]})"
            sleep(2)
        end
    end

    # prints out search researchs in neat format
    #
    # @param roster
    #   the hash for the roster data
    def search_output(roster) 
        # print out search results
        puts "\nRESULTS: \n"
        roster.each do |player|
            hash = player[1]
            name = player[0]
            puts name
            print "\tHeight: #{hash[:height]}"
            print "\t\tWeight: #{hash[:weight]}"
            puts "\tPosition: #{hash[:pos]}"
            print "\tYear: #{hash[:year]}"
            print "\t\tHometown: #{hash[:hometown]}\n"
        end
    end
end
