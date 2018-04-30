#redis-example.rb
require 'rubygems'
require 'bundler/setup'
require 'uri'
require 'sinatra'
require 'redis'


compose_redis_url = ENV["COMPOSE_REDIS_URL"]
parsed = URI.parse(compose_redis_url)
ssl_enabled = parsed.scheme == "rediss"


redis = Redis.new(
    url: compose_redis_url,
    ssl: ssl_enabled
    )


get '/' do
    erb :index
end


put '/words' do
    redis.hset("words", params[:word], params[:definition])
    return [204, ['']]
end


get '/words' do
    content_type :json
    results = redis.hgetall("words")

    all_words = results.map {|key, value| {"word": key, "definition": value}}
    return all_words.to_json
end
