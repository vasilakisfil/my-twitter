require 'sinatra/base'

module Sinatra
  module ViewHelpers
    def signed_in?
      !session[:user_id].nil?
    end
  end

  module VariousHelpers
    def csrf_token
      Rack::Csrf.csrf_token(env)
    end

    def csrf_tag
      Rack::Csrf.csrf_tag(env)
    end
  end
end
