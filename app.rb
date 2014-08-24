require 'sinatra'
require 'pry'
require 'csv'

#### Config ####
set :port, 9000

before do
  @movies ||= query_movies
end

def query_movies
  movies = []
  CSV.foreach('movies.csv', headers:true, header_converters: :symbol) do |row|
     movies << row.to_hash
  end
  movies
end

#### Model ####

def sort_movies_title(movies)
  movies.sort_by {|movie| movie[:title]}
end

# Shows 1 - 10 for first page, otherwise it displays (page number * 10) - next 10
def display_movie(sorted_movies, page_number)
  starting_number = page_number.to_i
  if starting_number == 1
    sorted_movies[(starting_number)..(page_number.to_i * 10)]
  else
    sorted_movies[(starting_number * 10)..((starting_number + 1) * 10)]
  end
end

# Finds a movie by a specific ID
def find_movie_by_id(movies,id)
  movies.find {|movie| movie[:id] == id}
end

def search(movies,params)
  search_results = []
  movies.each do |movie|
    if movie.value?(params)
      search_results << movie
    end
  end
  search_results
end

#### Routes ####
get '/' do
  redirect '/movies?page=1'
end

get '/movies' do
  @current_page_number = params[:page].to_i || 1
  @sorted_movies = sort_movies_title(@movies)

  if params.key?("query")
    @first_page = search(@movies,params[:query].capitalize)
  else
    @first_page = display_movie(@sorted_movies,params[:page])
  end

  erb :view_all_movies
end

get '/movies/:id' do
  @current_movie = find_movie_by_id(@movies,params[:id])
  erb :individual_movie
end
