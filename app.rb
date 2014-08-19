require 'sinatra'
require 'pry'
require 'csv'

set :port, 9000
movies = []
CSV.foreach('movies.csv', headers:true, header_converters: :symbol) do |row|
   movies << row.to_hash
end


get '/' do
  redirect '/movies'
end

get '/movies' do

  erb :view_all_movies
end
