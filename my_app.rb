require 'sinatra'
require_relative 'helpers'
require 'slim'
require 'twitter'
require 'json'
require 'sinatra/assetpack'


class MyApp < Sinatra::Base
  register Sinatra::AssetPack

  set :slim, :pretty => true

  assets do
    serve '/js', :from => 'assets/javascript'

    js :foundation, [
      '/js/foundation/foundation.js',
      '/js/foundation/foundation.*.js'
    ]

    js :application, [
      '/js/vendor/*.js',
      'js/app.js'
    ]

    serve '/css', :from => 'assets/css'
    css :application, [
      '/css/normalize.css',
      '/css/app.css'
    ]

    js_compression :jsmin
    css_compression :sass
  end



  before do
    #@twitter_helper = HelperUtils::TwitterHelper.new
  end

  get '/' do
    #@timeline = @twitter_helper.my_timeline
    @timeline = JSON.parse(File.read("spec/fixtures/user_timeline.json"))
    slim :index
  end

  get '/about' do
    "Hello world"
  end

  run! if app_file == $0
end
