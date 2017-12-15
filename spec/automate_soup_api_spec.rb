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
end
