require 'spec_helper'

RSpec.describe AutomateSoup::API do
  before(:all) do
    @soup = AutomateSoup.setup(
      url: ENV['AUTOMATE_URL'],
      username: ENV['AUTOMATE_USERNAME'],
      token: ENV['AUTOMATE_TOKEN']
    )
  end

  it 'should validate a status check' do
    expect(@soup.status).not_to be nil
  end

  it 'should fetch organizations in a default enterprise' do
    expect(@soup.orgs).not_to be nil
    names = @soup.orgs.collect { |o| o['name'] }
    expect(names).to include 'test'
    expect(names).to include 'ford'
  end
end
