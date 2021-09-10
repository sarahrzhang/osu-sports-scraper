require 'mechanize'
require 'nokogiri'
require 'csv'


class NewsScraper

    attr_accessor :news

    def initialize
        @news = {}
    end

    def scrape_news
        agent = Mechanize.new
        page = agent.get('https://ohiostatebuckeyes.com/sports/m-footbl/news/')


        # create hash to store all scraped data
        news = Hash.new

        # parse in news data (nodeset) - get element and all its nodes
        news_list = page.search('div[@class="sport_news_list"]')

        # Extract the dates for every single news listed on the website
        # news_dates = news_list.css('span').text.delete('Football')
        news_dates = news_list.xpath('//div[@class="inner"]/span')
        # Extract every single news' title 
        news_title = Hash[news_list.xpath('//div[@class="inner"]/a').map {|link| [link.text.strip, link["href"]]}].keys
        # Extract the link of the news listed on website 
        news_link = Hash[news_list.xpath('//div[@class="inner"]/a').map {|link| [link.text.strip, link["href"]]}].values

        # Create a database for all the news (title, date, link)
        # The database is constructed as a hash within a hash (key:title >> value: hash(link, date))
        news_title.each do |title|
            each_news={}
            each_news[:date] = news_dates.shift.text.delete('Football').strip
            each_news[:url] = news_link.shift
            @news[title.to_sym] = each_news
        end
    end

end



