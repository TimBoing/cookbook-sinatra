require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

before do
  csv_file = File.join(__dir__, 'recipes.csv')
  @cookbook = Cookbook.new(csv_file)
end

get '/' do
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  name = params[:name]
  description = params[:description]
  prep_time = params[:prep_time]
  difficulty = params[:difficulty]
  recipe = Recipe.new(name, description, prep_time, 'false', difficulty)
  @cookbook.add_recipe(recipe)
  erb :index
end

get '/dest/:index' do
  #puts params[:index].class
  @cookbook.remove_recipe(params[:index].to_i)
  erb :index
end
