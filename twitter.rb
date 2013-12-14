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
      Timeline.clear
      @client = twitter_client
    end

    def timeline
      @client.user_timeline("vasilakisfil")
    end

    def timeline_text
      text = ""
      @client.user_timeline("vasilakisfil").each do |tweet|
        text << tweet.text
        text << "\n"
      end
      return text
    end

  end

  class DataRetriever
    def initilize
    end

    def timeline
    end
  end
end

set_up = TwitterHelper::SetUp.new('vasilakisfil')
data_fetcher = TwitterHelper::DataFetcher.new(set_up.client)
puts data_fetcher.timeline_text
