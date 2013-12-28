require 'twitter'
require 'json'

module TwitterHelper

  class SetUp
    attr_reader :username, :client

    def initialize(username)
      Twitter.configure do |config|
        config.consumer_key        = "KgormCyO26dvrdUhooeMdw"
        config.consumer_secret     = "We7NbbWoVpqLU0yX2cjaoqnbPUEnA2rl4wTXMO7Ilc4"
      end
      @username = username
    end

    def authenticate
      @client = Twitter::Client.new(
        :oauth_token        => ENV['OAUTH_TOKEN'],
        :oauth_token_secret => ENV['OAUTH_TOKEN_SECRET']
      )
    end
  end

  class DataFetcher
    def initialize(twitter_client)
      @client = twitter_client
      @user_show_dir = 'database/user_show.json'
      @user_timeline_dir = 'database/user_timeline.json'
    end

    def user_show
      show_hash = {
        screen_name: @client.user('vasilakisfil').screen_name,
        name: @client.user('vasilakisfil').name,
        description: @client.user('vasilakisfil').description,
        profile_image_url: @client.user('vasilakisfil').profile_image_url,
        profile_background_image_url:
          @client.user('vasilakisfil').profile_background_image_url,
        url: @client.user('vasilakisfil').url,
        statuses_count: @client.user('vasilakisfil').statuses_count,
        friends_count: @client.user('vasilakisfil').friends_count,
        followers_count: @client.user('vasilakisfil').followers_count
      }
      File.open(@user_show_dir, 'w') {}
      File.open(@user_show_dir, 'w') do |f|
        f.write(show_hash.to_json)
      end
    end

    def user_timeline
      timeline = []
      @client.user_timeline("vasilakisfil").each do |tweet|
        tweet = { created_at: tweet.created_at, text: tweet.text }
        timeline.push(tweet)
      end
      File.open(@user_timeline_dir, 'w') {}
      File.open(@user_timeline_dir, 'w') do |f|
        f.write(timeline.to_json)
      end
    end

    def clear_db
      File.open(@user_show_dir, 'w') {}
      File.open(@user_timeline_dir, 'w') {}
    end

  end

  class DataRetriever
    def initialize
      @user_show_dir = 'database/user_show.json'
      @user_timeline_dir = 'database/user_timeline.json'
    end

    def user_show
      show_hash = JSON.parse(File.read(@user_show_dir))
    end

    def user_timeline
      timeline_hash = JSON.parse(File.read(@user_timeline_dir))
    end
  end
end


=begin
set_up = TwitterHelper::SetUp.new('vasilakisfil')
set_up.authenticate

data_fetcher = TwitterHelper::DataFetcher.new(set_up.client)
data_fetcher.user_show
sleep(25)
data_fetcher.user_timeline

data_retriever = TwitterHelper::DataRetriever.new
p data_retriever.user_show
p data_retriever.user_timeline
=end

