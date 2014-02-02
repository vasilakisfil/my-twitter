require 'twitter'
require 'json'
require 'httpclient'

module TwitterHelper

  class SetUp
    attr_reader :username, :client

    def initialize
      Twitter.configure do |config|
        config.consumer_key        = "KgormCyO26dvrdUhooeMdw"
        config.consumer_secret     = "We7NbbWoVpqLU0yX2cjaoqnbPUEnA2rl4wTXMO7Ilc4"
      end
    end

    def authenticate(username)
      yaml_config = YAML::load_file('config.yml')
      @client = Twitter::Client.new(
        :oauth_token        => yaml_config['oauth']['OAUTH_TOKEN'],
        :oauth_token_secret => yaml_config['oauth']['OAUTH_TOKEN_SECRET']
      )
      @username = username
    end
  end

  class DataFetcher
    attr_reader :username
    def initialize(twitter_client, username)
      @client = twitter_client
      @user_show_dir = 'database/user_show.json'
      @user_timeline_dir = 'database/user_timeline.json'
      @username = username
    end

    def user_show
      show_hash = {
        screen_name: @client.user(username).screen_name,
        name: @client.user(username).name,
        description: @client.user(username).description,
        profile_image_url: @client.user(username).profile_image_url_https,
        profile_background_image_url:
          @client.user(username).profile_background_image_url_https,
        url: @client.user(username).url,
        statuses_count: @client.user(username).statuses_count,
        friends_count: @client.user(username).friends_count,
        followers_count: @client.user(username).followers_count
      }
      show_hash[:url] = final_url(show_hash[:url])
      File.open(@user_show_dir, 'w') {}
      File.open(@user_show_dir, 'w') do |f|
        f.write(show_hash.to_json)
      end
    end

    def user_timeline
      timeline = []
      @client.user_timeline(username).each do |tweet|
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

    private

    def final_url(url)
      httpc = HTTPClient.new
      resp = httpc.head(url)
      return resp.header['Location'][0]
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

  def TwitterHelper.send_tweet(client, tweet)
    data_fetcher = DataFetcher.new(client, client.current_user.screen_name)
    client.update(tweet)
    data_fetcher.user_timeline
  end



end

