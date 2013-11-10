require 'sinatra'
require 'slim'
require 'twitter'



class MyApp < Sinatra::Base
=begin
  Twitter.configure do |config|
    config.consumer_key        = "KgormCyO26dvrdUhooeMdw"
    config.consumer_secret     = "We7NbbWoVpqLU0yX2cjaoqnbPUEnA2rl4wTXMO7Ilc4"
  end

  @my_twitter = Twitter::Client.new(
    :oauth_token        => ENV['OAUTH_TOKEN'],
    :oauth_token_secret => ENV['OAUTH_TOKEN_SECRET']
  )

  before do
    @my_timeline = Twitter.user_timeline("vasilakisfil")
    @my_user = Twitter.user("vasilakisfil")
    p @my_user.description
  end

  get '/' do
    @test_var = "Random Test"
    slim :index
  end

  get '/about' do
    "Hello world"
  end

=end
  get '/test' do
    slim :test
  end

  run! if app_file == $0
end
