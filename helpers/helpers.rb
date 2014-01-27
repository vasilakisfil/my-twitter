require 'sinatra/base'

module Sinatra
  module ViewHelpers
    def signed_in?
      !session[:user_authenticated].nil?
    end
  end
end
