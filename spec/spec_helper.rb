require 'sinatra'
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require File.expand_path(File.dirname(__FILE__) + '../../my_app')

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Capybara::DSL
end




