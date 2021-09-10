require 'mechanize'
require 'nokogiri'

class RosterScraper
    attr_reader :roster

    # initialize variables to store all scraped data
    #
    # @param roster 
    #    the hash that will store our data
    # @param url
    #   the website to be scraped
    def initialize(roster, url)
        @roster = roster
        @url = url
    end

    # scrapes data from the webpages
    #
    # returns a hash of the roster data
    def scrape_roster 
        # create mechanize object
        agent = Mechanize.new
        page = agent.get(@url)

        # parse in roster data (nodeset) - get element and all its nodes
        players_list = page.search('div[@class="roster-photo"]')
        players_list = players_list.first

        # scrape players names
        names = players_list.search('h3[class=ohio-square-blocks__title]')
        # scrape heights and weights
        heights_and_weights = players_list.search('span[class=ohio-square-blocks__subtitle]')
        # scrape additional info
        info = players_list.search('div[class=meta__row]')
        info = info.search('p')

        # put data into hash
        names.each do |name|
            # create hash for each player's info
            data = {}
            name_array = name.text.split
            # add first name
            data[:first] = name_array[0]
            # add last name
            data[:last] = name_array[1]
            
            # get height and weight for each player
            string = heights_and_weights.shift.text
            h_w_array = string.split
            # add height
            data[:height] = h_w_array[0]
            # add weight
            data[:weight] = h_w_array[1]
            # get player's position
            data[:pos] = info.shift.text
            # get player's year
            data[:year] = info.shift.text

            # get player's hometown
            hometown = info.shift.text
            # get more specific info about city
            data[:hometown] = hometown
            hometown_array = hometown.split(',')
            # add city
            data[:city] = hometown_array[0].strip
            # add state/country/territory
            if hometown_array.length > 1
                data[:state] = hometown_array[1].strip
            else
                data[:state] = 'N/A'
            end
            @roster[name.text.to_sym] = data
        end
    end
end
