require 'spec_helper'
require 'json'

RSpec.configure do |config|
  config.include Capybara::DSL
end


Capybara.app = MyApp

feature "Tweets" do
  before(:each) do
    twitter_helper = double
    HelperUtils::TwitterHelper.stub(:new).and_return(twitter_helper)
    # bad style ?
    twitter_helper.stub(:my_timeline).and_return
    (
      JSON.parse(File.read("spec/fixtures/user_timeline.json"))
    )
  end

  scenario "Tweets are shown in main page" do
    visit '/'
    expect(page).to have_content("Introducing the Twitter Certified
                                 Products Program: https://t.co/MjJ8xAnT")
    expect(page).to have_content("we are working to resolve issues with
                                 application management &amp; logging in to
                                 the dev portal: https://t.co/p5bozh0k ^ts")
  end
end
