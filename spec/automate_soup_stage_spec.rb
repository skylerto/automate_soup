require 'spec_helper'

RSpec.describe AutomateSoup::Stage do
  before(:all) do
    @soup = AutomateSoup.setup(
      url: ENV['AUTOMATE_URL'],
      username: ENV['AUTOMATE_USERNAME'],
      token: ENV['AUTOMATE_TOKEN']
    )
    @organization = ENV['AUTOMATE_ORG'] || 'test'
    @project = ENV['AUTOMATE_PROJECT'] || 'coffee_docker'
    @pipeline = ENV['AUTOMATE_PIPELINE'] || 'master'
    @topic = @soup.change_by_topic(
      organization: @organization,
      project: @project,
      pipeline: @pipeline,
      topic: 'foobarbaz'
    )
  end

  it 'should determine the status of the current stage' do
    stage = @topic.current_stage
    expect(stage.status).not_to be nil
  end

  it 'should determine if the stage passed' do
    stage = @topic.current_stage
    stage.status = 'passed'
    expect(stage.passed?).not_to be nil
    expect(stage.passed?).to be true
  end

  it 'should determine if the stage failed' do
    stage = @topic.current_stage
    stage.status = 'failed'
    expect(stage.passed?).not_to be nil
    expect(stage.passed?).to be false
  end
end
