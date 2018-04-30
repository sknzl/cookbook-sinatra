require_relative "cookbook"
require_relative "recipe"
require_relative "service"
require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

cookbook = Cookbook.new("recipes.csv")
service = Service.new
online_recipe = []

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

get '/import' do
  erb :import
end

get '/about' do
  erb :about
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end

# get '/add?name=:name&description=:description' do
post '/add' do
  # binding.pry
  recipe = Recipe.new(params[:name], params[:description])
  cookbook.add_recipe(recipe)
  redirect "/"
end

post '/search' do
  # binding.pry
  @online_recipe = service.search_online(params[:keyword])
  erb :show_search_results
end

get '/delete/:index' do
  # binding.pry
  cookbook.remove_recipe(params[:index].to_i)
  redirect "/"
end

get '/mark/:index' do
  # binding.pry
  cookbook.mark_recipe(params[:index].to_i)
  redirect "/"
end

get '/unmark/:index' do
  # binding.pry
  cookbook.unmark_recipe(params[:index].to_i)
  redirect "/"
end

post '/import_recipe' do
  # binding.pry
  # recipe_url = params[:]
  data = service.import_online({url: params[:url], title: params[:title]})
  recipe = Recipe.new(data[0], data[1])
  cookbook.add_recipe(recipe)
  redirect "/"
end


