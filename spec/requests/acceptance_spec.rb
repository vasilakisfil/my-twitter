require 'spec_helper'

RSpec.configure do |config|
  config.include Capybara::DSL
end


Capybara.app = MyApp

describe "In the main page" do
  before(:each) do
    puts "Hello World"
    visit '/test'
  end

  it "tweets are shown" do
    p page
    expect(page).to have_content "Hello"
    expect(page).to have_content "World"
    expect(page).not_to have_content "asjdghajsdhgajsdhgajsdghajdsh"
  end
end
