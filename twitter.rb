require 'highland'
require 'twitter'

module TwitterHelper

  class SetUp
    attr_reader :username, :client

    def initialize(username)
      Twitter.configure do |config|
        config.consumer_key        = "KgormCyO26dvrdUhooeMdw"
        config.consumer_secret     = "We7NbbWoVpqLU0yX2cjaoqnbPUEnA2rl4wTXMO7Ilc4"
      end

      @client = Twitter::Client.new(
        :oauth_token        => ENV['OAUTH_TOKEN'],
        :oauth_token_secret => ENV['OAUTH_TOKEN_SECRET']
      )
      @username = username
    end
  end

  class DataFetcher
    def initialize(twitter_client)
      UserTimeline.clear
      @client = twitter_client
    end

    def user_timeline
      @client.user_timeline("vasilakisfil").each do |tweet|
        UserTimeline.create(create_at: tweet.created_at, text: tweet.text)
      end
    end

    def user_show
      User.create(
        screen_name: @client.user('vasilakisfil').screen_name,
        name: @client.user('vasilakisfil').name,
        description: @client.user('vasilakisfil').description,
        statuses_count: @client.user('vasilakisfil').statuses_count,
        friends_count: @client.user('vasilakisfil').friends_count,
        followers_count: @client.user('vasilakisfil').followers_count
      )
    end
  end

  class DataRetriever
    def initialize(twitter_client)
      @client = twitter_client
    end

    def user_timeline
      User.all
    end
  end
end

set_up = TwitterHelper::SetUp.new('vasilakisfil')
#data_fetcher = TwitterHelper::DataFetcher.new(set_up.client)
#puts data_fetcher.timeline_text
#data_fetcher.user_show
#data_fetcher.user_timeline
data_retriever = TwitterHelper::DataRetriever.new(set_up.client)
#p data_retriever.user_timeline
data =  data_retriever.user_timeline
p data
