require 'pony'
require 'date'
require_relative './football_news_scraper'

fball_news_scraper = NewsScraper.new
fball_news_scraper.scrape_news
puts fball_news_scraper.news

# # Get user email
# puts "Please enter your email for football news: "
# user_email = get.chomp().to_s

# # Ask user for the specific date they want to retrieve the football news
# puts "Which date of the news do you want to see? (Please enter in the form of 01/01/2021)"
# puts "If the date you entered is not available for news retrival, you would not get an email from us. "
# month = get.chomp().to_s


# user_month = Date.today.striftime("%m")




Pony.mail(:to => user_email, :via => :smtp, :via_options => 
    {
        :address => 'smtp.gmail.com',                     
        :port => '587',
        :enable_starttls_auto => true,
        :user_name => 'osufootballnews@gmail.com',
        :password => 'bitsplease4',
        :authentication => :plain,
        :domain => "HELO",
     },
    :subject => 'Test', :body => "bla bla bla or #{$body}",         
)