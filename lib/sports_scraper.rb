require 'mechanize'
require 'nokogiri'
require 'gruff'
require_relative './roster_scraper'
require_relative './roster_stats'
require_relative './graphs'

# define functions 

# method for scraping and conducting searches on a specific page
#
# @param roster
#   the hash for our roster data
# @param stats
#   the RosterStats instance for a specific roster
# @param url
#   the url to scrape for data
# @param search_num
#   the count of the number of consecutive searches
def scrape_and_search(roster, stats, url, search_num)
    # create scraper and pass correct url
    scraper = RosterScraper.new(roster, url)
    # perform scraping
    scraper.scrape_roster
    # obtain stats and perform search on data
    stats.search_roster
    # get more data upon user request if at least one player in roster
    unless roster.empty?
        more_data(stats, search_num)
    end
end

# allow user to perform further analysis on a searched data set
# @param stats
#   the statistics of each player
# @param search_num
#   the counter for consecutive searches
def more_data(stats, search_num)
    done = false
    until done
        puts "\nBased on the most recent search, input one of these letters followed by ENTER:\n'b' to see biometrics information\n'c' for an attribute count search\n'g' for graphical data\n'n' for no more data"
        # get user input
        input = gets.chomp.downcase
        case input
        when 'b' # calculate and output biometrics data for heights and weights
            stats.heights
            stats.weights
        when 'c' # count the number of a specified attribute
            # choose between year, state/location, or position
            puts "Choose the attribute to search by:\n's' for state/country\n'p' for position\n'y' for year\n"
            attribute = gets.chomp.downcase
            case attribute
            when 'y' # count by year
                stats.get_attribute_count(:year)
            when 'p' # count by position
                stats.get_attribute_count(:pos)
            when 's' # count by state/country
                stats.get_attribute_count(:state)
            else 
                puts "Invalid search criteria.\n"
            end
        when 'g' # generate two graphs for weights and positions
            graph = Graphs.new(stats.roster, stats.sport, search_num)
            graph.histogram_weights
            graph.pie_positions
            puts 'Graphs generated. Check graphs folder.'
            sleep (2) # brief pause
        when 'n' # exit loop
            done = true
        else # user enters invalid command
            puts "Invalid input. Try again\n"
        end
    end
end

# main method for getting user input and printing stats

# base url
url = 'https://ohiostatebuckeyes.com/sports'
# print menu for sports search tool
puts "Welcome to our OSU Men's Athletics Search Tool"
puts "This tool allows you to gather, analyze, and compare information about each team's roster"

# create boolean looping variable
done = false
# variable to keep track of the number of searches
search_number = 1
# start search tool
while !done
    puts "\nTo use this tool, please enter one of the following sports (enter 'q' to quit, 'g' for search guidelines):\n
    \tBaseball \tBasketball \tFootball\n
    \tHockey \t\tLacrosse \tSoccer"
    # get users input
    input = gets.chomp.downcase
    case input
    when 'baseball' # perform scrape and search for men's baseball 
        # create hash to scrape roster info
        baseball_roster = {}
        # create stats
        baseball_stats = RosterStats.new(baseball_roster, 'Baseball')
        # create scraper by passing correct url, perform scrape and search
        scrape_and_search(baseball_roster, baseball_stats, url + '/m-basebl/roster/', search_number)
    when 'basketball' # perform scrape and search for men's basketball 
        # create hash to scrape roster info
        basketball_roster = {}
        # create stats
        basketball_stats = RosterStats.new(basketball_roster, 'Basketball')
        # create scraper by passing correct url, perform scrape and search
        basketball_scraper = scrape_and_search(basketball_roster, basketball_stats, url + '/m-baskbl/roster/', search_number)
    when 'football' # perform scrape and search for men's football
        # create hash to scrape roster info
        fball_roster = {}
        # create stats
        fball_stats = RosterStats.new(fball_roster, 'Football')
        # create scraper by passing correct url, perform scrape and search
        fball_scraper = scrape_and_search(fball_roster, fball_stats, url + '/m-footbl/roster/', search_number)
    when 'hockey' # perform scrape and search for men's hockey 
        # create hash to scrape roster info
        hockey_roster = {}
        # create stats
        hockey_stats = RosterStats.new(hockey_roster, 'Hockey')
        # create scraper by passing correct url, perform scrape and search
        hockey_scraper = scrape_and_search(hockey_roster, hockey_stats, url + '/m-hockey/roster/', search_number)
    when 'lacrosse' # perform scrape and search for men's lacrosse
        # create hash to scrape roster info
        lax_roster = {}
        # create stats
        lax_stats = RosterStats.new(lax_roster, 'Lacrosse')
        # create scraper by passing correct url, perform scrape and search
        lax_scraper = scrape_and_search(lax_roster, lax_stats, url + '/m-lacros/roster/', search_number)
    when 'soccer' # perform scrape and search for men's soccer 
        # create hash to scrape roster info
        soccer_roster = {}
        # create stats
        soccer_stats = RosterStats.new(soccer_roster, 'Soccer')
        # create scraper and pass correct url
        soccer_scraper = scrape_and_search(soccer_roster, soccer_stats, url + '/m-soccer/roster/', search_number)
    when 'g' # print guidelines for searching by position
        puts "GUIDELINES:\n \tSearchable Baseball Positions: 1B, C, INF, LHP, OF, OF/1B,  RHP, P, UTIL\n
        Searchable Basketball Positions: Center, Forward, Guard\n
        Searchable Football Positions: CB, DE, DT, K, LB, LS, OC, OL, P, QB, RB, SAF, TE, WR\n
        Searchable Hockey Positions: Defenseman, Forward, Goaltender\n
        Searchable Lacrosse Positions: Attack, Defense, Defense/LSM, Face-off, Goalie, Midfield\n
        Searchable Soccer Positions: Defender, Forward, Goalkeeper, Midfielder\n"
    when 'q' # print goodbye message and exit loop
        puts "\nGoodbye and Go Bucks!"
        done = true
    else # user enters invalid input
        puts "Invalid command. Please try again.\n"
    end
    search_number += 1 # increment number of searches
end
