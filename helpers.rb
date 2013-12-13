module HelperUtils

  class TwitterHelper
    def initialize
      Twitter.configure do |config|
        config.consumer_key        = "KgormCyO26dvrdUhooeMdw"
        config.consumer_secret     = "We7NbbWoVpqLU0yX2cjaoqnbPUEnA2rl4wTXMO7Ilc4"
      end

      @my_twitter = Twitter::Client.new(
        :oauth_token        => ENV['OAUTH_TOKEN'],
        :oauth_token_secret => ENV['OAUTH_TOKEN_SECRET']
      )
    end

    def my_timeline
      Twitter.user_timeline("vasilakisfil")
    end
  end
end
