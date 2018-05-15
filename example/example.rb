#example.rb
require 'sinatra'

all_words = []

get '/' do
    erb :index
end


put '/words' do
    new_word = {"word" => params[:word], "definition" => params[:definition]}
    all_words.push(new_word)
    return [204, ['']]
end


get '/words' do
    content_type :json
    return all_words.to_json
end