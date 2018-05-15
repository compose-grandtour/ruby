require 'sinatra'
require 'pg'
require 'uri'

# store your Compose PostgreSQL connection string and certificate path in variables from the environment variables
compose_postgresql_url = ENV['COMPOSE_POSTGRESQL_URL']
compose_postgresql_cert = ENV['PATH_TO_POSTGRESQL_CERT']

# tell the 'uri' to parse the Compose PostgreSQL connection string
uri = URI compose_postgresql_url

# create a new connection to Compose PostgreSQL.
# the 'uri' library will grab the host, port, user, and password from your Compose PostgreSQL connection string
conn = PG::Connection.new(
    host: uri.host,
    port: uri.port,
    user: uri.user,
    password: uri.password,
    dbname: 'grand_tour',
    sslmode: 'require',
    sslrootcert: compose_postgresql_cert
)

# creates a table called 'words' if it doesn't already exist
conn.exec('
    CREATE TABLE IF NOT EXISTS words (
        id SERIAL NOT NULL PRIMARY KEY,
        word VARCHAR(255) NOT NULL,
        definition VARCHAR(255) NOT NULL
    )'
)

# initial page load
get '/' do 
    erb :index
end

# The PUT route will save a word and its definition
put '/words' do
    # triggers when 'Add' button is clicked
    # pulls word, definition from HTML fields and inserts into table
    conn.exec_params('INSERT INTO words (word, definition) VALUES ($1, $2)', [params[:word], params[:definition]])
    status 204
end


# The GET route will return the words and their definition
get '/words' do
    # content is set to application/json
    content_type :json
    # queries for all rows in the table, returns an object that resembles an array  
    results = conn.exec('SELECT word, definition FROM words')
    # iterates through each result and returns them as JSON to display on the page
    return results.map {|row| row}.to_json
end




