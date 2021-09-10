#Testing cases for roster scraper program

require 'mechanize'
require 'nokogiri'
require 'gruff'
require 'mechanize'
require 'minitest/autorun' # the test runner
require_relative '../lib/roster_scraper.rb'
require_relative '../lib/roster_stats.rb' # the UUT

class TestRosterStats < MiniTest::Test
    
    def setup
        @agent = Mechanize.new
    end

    # Test search_criteria method Case1
    def test_search_criteria_case1
        test_input = "Lawrence"
        test_roster = {:"Element1"=>{:fname=>"Lawrence", :lname=>"Gallagher"}, :"Element2"=>{:fname=>"Aiko", :lname=>"Mcneil"}}
        test_key = :fname
        test_dataset = RosterStats.new(test_roster, "Sports")
        test_dataset.search_criteria(test_input, test_key, test_roster)
        expected_dataset = {:"Element1"=>{:fname=>"Lawrence", :lname=>"Gallagher"}}
        assert_equal expected_dataset, test_roster
    end

    # Test search_criteria method Case2
    def test_search_criteria_case2
        test_input = "Hello"
        test_roster = {:"X"=>{:fname=>"Hello", :lname=>"tada"}, :"Y"=>{:fname=>"qwei", :lname=>"opsd"}}
        test_key = :fname
        test_dataset = RosterStats.new(test_roster, "Sports")
        test_dataset.search_criteria(test_input, test_key, test_roster)
        expected_dataset = {:"X"=>{:fname=>"Hello", :lname=>"tada"}}
        assert_equal expected_dataset, test_roster
    end

    # Test search_criteria method Case3
    def test_search_criteria_case3
        test_input = "yoo"
        test_roster = {:"Star"=>{:fname=>"Sta", :lname=>"tada"}, :"Y"=>{:fname=>"hi", :lname=>"yoo"}}
        test_key = :lname
        test_dataset = RosterStats.new(test_roster, "Sports")
        test_dataset.search_criteria(test_input, test_key, test_roster)
        expected_dataset = {:"Y"=>{:fname=>"hi", :lname=>"yoo"}}
        assert_equal expected_dataset, test_roster
    end

end
