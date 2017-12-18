require 'spec_helper'

RSpec.describe AutomateSoup::Topic do
  before(:all) do
    @soup = AutomateSoup.setup(
      url: ENV['AUTOMATE_URL'],
      username: ENV['AUTOMATE_USERNAME'],
      token: ENV['AUTOMATE_TOKEN']
    )
    @organization = ENV['AUTOMATE_ORG'] || 'test'
    @project = ENV['AUTOMATE_PROJECT'] || 'coffee_docker'
    @pipeline = ENV['AUTOMATE_PIPELINE'] || 'master'
    @topic = @soup.topic(
      organization: @organization,
      project: @project,
      pipeline: @pipeline,
      topic: 'foobarbaz'
    )
  end

  it 'should determine the topic stage' do
    topic = @topic.current_stage
    expect(topic).not_to be nil
  end
end
