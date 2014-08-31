require 'rubygems'
require 'twitter'
require 'sinatra/base'
require 'redis'
require 'json'

class WhoFollows < Sinatra::Base

configure do
    enable :sessions
    set :public_folder, Proc.new { File.join(__dir__, 'static') }

    if (ENV['VCAP_SERVICES']).nil?
      REDIS_CLIENT = Redis.new(:host => 'localhost', :port => 6379)
    else
      services = JSON.parse(ENV['VCAP_SERVICES'])
      redis_key = services.keys.select { |svc| svc =~ /redis/i }.first
      redis = services[redis_key].first['credentials']
      redis_conf = {host: redis['hostname'], port: redis['port'], password: redis['password']}
      REDIS_CLIENT = Redis.new redis_conf
    end

    TWITTER_CLIENT = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TW_CONSUMER_KEY']
      config.consumer_secret     = ENV['TW_CONSUMER_SECRET']
      config.access_token        = ENV['TW_ACCESS_TOKEN']
      config.access_token_secret = ENV['TW_ACCESS_TOKEN_SECRET']
    end
end

helpers do
    def twitter_id(screen_name)
        TWITTER_CLIENT.user(screen_name).id
    end

    def is_following?(a,b)
        followers = TWITTER_CLIENT.follower_ids(twitter_id(b)).to_a
        followers.include?(twitter_id(a))
    end

    def update_leaderboard(a,b)
        a_score = REDIS_CLIENT.hincrby 'user:scores', a, 1
        b_score = REDIS_CLIENT.hincrby 'user:scores', b, 1
        REDIS_CLIENT.zadd 'high:scores', a_score, a
        REDIS_CLIENT.zadd 'high:scores', b_score, b
    end

    def get_leaders
        REDIS_CLIENT.zrevrangebyscore('high:scores', '+inf', '-inf')[0..9]
    end
end

get '/' do
    @leaders = get_leaders
    erb :index
end

get '/follows' do
    @user1 = params[:user1]
    @user2 = params[:user2]
    @following = is_following?(@user1, @user2)
    update_leaderboard(@user1, @user2)
    erb :follows
end

get '/cleardb' do
    REDIS_CLIENT.flushdb
    redirect to('/'), 303
end

error do
    @error = env['sinatra.error']
    erb :error
end

end
