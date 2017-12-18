require 'spec_helper'

RSpec.describe AutomateSoup::Topic do
  before(:all) do
    @organization = ENV['AUTOMATE_ORG'] || 'test'
    @project = ENV['AUTOMATE_PROJECT'] || 'coffee_docker'
    @pipeline = ENV['AUTOMATE_PIPELINE'] || 'master'
    @soup = AutomateSoup.setup(
      url: ENV['AUTOMATE_URL'],
      username: ENV['AUTOMATE_USERNAME'],
      token: ENV['AUTOMATE_TOKEN'],
      organization: @organization,
      project: @project,
      pipeline: @pipeline
    )
    @topic = @soup.topic(
      topic: 'foobarbaz'
    )
  end

  it 'should determine the topic stage' do
    stage = @topic.current_stage
    expect(stage).not_to be nil
  end

  it 'should approve a change or return nil if it cannot' do
    topic = @topic
    approve = topic.approve
    if approve.nil?
      expect(topic.current_stage.stage).not_to be nil
      expect(topic.current_stage.stage).not_to eql 'approve'
    else
      expect(approve).to be true
    end
  end

  it 'should deliver a change or return nil if it cannot' do
    topic = @topic
    deliver = topic.deliver
    if deliver.nil?
      expect(topic.current_stage.stage).not_to be nil
      expect(topic.current_stage.stage).not_to eql 'approve'
    else
      expect(deliver).to be true
    end
  end
end
