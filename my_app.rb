require 'sinatra'
require 'sinatra/assetpack'
require 'slim'
require 'json'
require 'sinatra/partial'
require_relative 'helpers/twitter'


class MyApp < Sinatra::Base
  register Sinatra::AssetPack
  register Sinatra::Partial
  set :slim, :pretty => true
  set :partial_template_engine, :slim

  helpers TwitterHelper

  Thread.new do
    @set_up = TwitterHelper::SetUp.new
    @set_up.authenticate('vasilakisfil')
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
    @user_timeline = @data_retriever.user_timeline
    @user_show = @data_retriever.user_show
    slim :following
  end

  run! if app_file == $0
end
