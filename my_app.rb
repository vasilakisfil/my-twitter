require 'sinatra'
require 'sinatra/assetpack'
require 'slim'
require 'json'
require 'yaml'
require 'scrypt'
require 'sinatra/partial'
require_relative 'helpers/twitter'
require_relative 'helpers/helpers'

module MyTwitter

  class MyApp < Sinatra::Base
    register Sinatra::AssetPack
    register Sinatra::Partial
    set :slim, :pretty => true
    set :partial_template_engine, :slim
    #enable :sessions
    #use Rack::Session::Cookie, {:http_only => true }

    helpers TwitterHelper
    helpers Sinatra::ViewHelpers


    yaml_config = YAML::load_file('config.yml')
    screen_name = username = yaml_config['screen_name']

    Thread.new do
      @set_up = TwitterHelper::SetUp.new
      @set_up.authenticate(screen_name)
      data_fetcher = TwitterHelper::DataFetcher.new(@set_up.client, @set_up.username)
      while true do
        puts "Fetching data from Twitter REST API"
        data_fetcher.user_show
        sleep(25)
        data_fetcher.user_timeline
        sleep(180)
      end
    end

    assets do
      serve '/js', :from => 'assets/javascript'

      js :foundation, [
        '/js/foundation/foundation.js',
        '/js/foundation/foundation.*.js'
      ]

      js :application, [
        '/js/vendor/*.js',
        '/js/app.js'
      ]

      serve '/css', :from => 'assets/css'
      css :application, [
        '/css/app.css'
      ]

     serve '/images', :from => 'assets/images'
     # images :application, [
     #   '/images/*'
     # ]

      js_compression :jsmin
      css_compression :sass
    end



    before do
      @data_retriever = TwitterHelper::DataRetriever.new
    end

    get '/' do
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :index
    end

    get '/vasilakisfil' do
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :index
    end

    post '/vasilakisfil' do
      key_len = yaml_config['password']['key_len']
      salt = yaml_config['password']['salt']
      hashed_pass = yaml_config['password']['hash']
      pass = params[:password]
      new_hashed_pass = SCrypt::Engine.hash_secret(params[:password], salt, 512)
      session[:user_authenticated] = screen_name if hashed_pass == new_hashed_pass
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :index
    end

    get '/following' do
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :following
    end

    get '/followers' do
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :following
    end

    get '/favorites' do
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :following
    end

    get '/lists' do
      session.clear
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :following
    end

    run! if app_file == $0

  end
end
