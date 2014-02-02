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
    helpers Sinatra::VariousHelpers


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
      @home_page = true
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :index
    end

    get '/vasilakisfil' do
      @me_page = true
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :index
    end

    post '/session' do
      if params[:_method] == "DELETE"
        session.clear
      else
        key_len = yaml_config['password']['key_len']
        salt = yaml_config['password']['salt']
        hashed_pass = yaml_config['password']['hash']
        pass = params[:password]
        new_hashed_pass = SCrypt::Engine.hash_secret(params[:password], salt, 512)
        session[:user_authenticated] = screen_name if hashed_pass == new_hashed_pass
      end
      redirect to('/vasilakisfil')
    end

    delete '/session' do
      session.clear
      redirect to('/')
    end

    get '/connect' do
      @connect_page = true
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :index
    end

    get '/discover' do
      @discover_page = true
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :index
    end

    get '/following' do
      @following_page = true
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :following
    end

    get '/followers' do
      @followers_page = true
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :following
    end

    get '/favorites' do
      @favorites_page = true
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :following
    end

    get '/lists' do
      @lists_page = true
      @user_timeline = @data_retriever.user_timeline
      @user_show = @data_retriever.user_show
      slim :following
    end

    run! if app_file == $0

  end
end
