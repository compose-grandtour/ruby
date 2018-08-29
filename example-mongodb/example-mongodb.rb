#example-mongodb.rb

require 'sinatra'
require 'mongo'

compose_mongodb_url = ENV['COMPOSE_MONGODB_URL']
compose_mongodb_cert = ENV['PATH_TO_MONGODB_CERT']

options = {}

# If the path to the certificate is set, we assume SSL with a selfsigned cert
# Therefore we read the cert and set the options for a selfsigned SSL connection
if compose_mongodb_cert
    options = {ssl: true, ssl_ca_cert: compose_mongodb_cert, database: "grand_tour"}
else 
    options = {ssl: true, database: "grand_tour"}
end

# set up a new client using your Compose MongoDB URL, sets database, will create if it doesn't exist
client = Mongo::Client.new(compose_mongodb_url, options)

# set collection, will create if it doesn't exist
collection = client['words']


# initial page load
get '/' do 
    erb :index
end


# The PUT route will save a word and its definition
put '/words' do
    # triggers when the 'Add' button is clicked 
    # creates a new document from the HTML fields
    new_word = {word: params[:word], definition: params[:definition]}
    
    # inserts document into collection
    collection.insert_one(new_word)
    status 204 
end


# The GET route will return the words and their definitions
get '/words' do
    content_type :json
    # the database will return all in 'words' as an array, and that array is returned as JSON for display on page.
    results = collection.find().to_a.to_json
    return results
end



