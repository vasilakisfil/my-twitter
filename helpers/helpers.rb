require 'sinatra/base'

module Sinatra
  module ViewHelpers
    def signed_in?
      return false
    end
  end
end
