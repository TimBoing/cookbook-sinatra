require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require 'nokogiri'
require 'open-uri'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

before do
  # csv_file = File.join(__dir__, 'recipes.csv')
  # @cookbook = Cookbook.new(csv_file)
  # @url = "https://fr.wikipedia.org/wiki/Train"
  # @doc = Nokogiri::HTML(open(@url), nil, 'utf-8')
  @file = 'wagon.html'
  @doc = Nokogiri::HTML(File.open(@file), nil, 'utf-8')
  puts "I´m scrapping"
end

get '/' do
  @first_heading = @doc.search('.firstHeading').text.strip
  @p_content = @doc.search('.mw-parser-output p').text.strip
  @a_array = []
  @doc.search('a').each do |elem|
    unless elem.attribute('title').nil?
      if elem.attribute('href').to_s.chars.first(6).join == "/wiki/"
        @a_array << { title: elem.attribute('title'), ref: "https://fr.wikipedia.org#{elem.attribute('href')}" }
      end
    end
  end

  @a_array.each do |link|
    puts "looking in #{link[:title]}"
    sleep(1)
    link[:children] = []
    @url = link[:ref]
    begin
      @doc = Nokogiri::HTML(open(@url), nil, 'utf-8')
    rescue
      next
    end

    @doc.search('a').each do |elem|

      unless elem.attribute('title').nil?
        if elem.attribute('href').to_s.chars.first(6).join == "/wiki/"
          link[:children] << { title: elem.attribute('title'), ref: "https://fr.wikipedia.org#{elem.attribute('href')}" }
          puts "found : #{elem.attribute('title')}"
        end
      end
    end
  end
  erb :index
end




