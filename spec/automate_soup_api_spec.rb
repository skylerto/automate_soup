require 'spec_helper'

RSpec.describe AutomateSoup::API do
  before(:all) do
    @soup = AutomateSoup.setup(
      url: ENV['AUTOMATE_URL'],
      username: ENV['AUTOMATE_USERNAME'],
      token: ENV['AUTOMATE_TOKEN']
    )
    @organization = ENV['AUTOMATE_ORG'] || 'test'
    @project = ENV['AUTOMATE_PROJECT'] || 'coffee_docker'
    @pipeline = ENV['AUTOMATE_PIPELINE'] || 'master'
  end

  it 'should validate a status check' do
    expect(@soup.status).not_to be nil
  end

  it 'should fetch organizations in a default enterprise' do
    expect(@soup.orgs).not_to be nil
    names = @soup.orgs.collect { |o| o['name'] }
    expect(names).to include 'test'
  end

  it 'should fetch projects for an organization given a enterprise and an org' do
    projects = @soup.projects(
      organization: @organization
    )
    expect(projects).not_to be nil
  end

  it 'should fetch a projects pipelines for an organization given a enterprise and an org' do
    pipelines = @soup.pipelines(
      organization: @organization,
      project: @project
    )
    expect(pipelines).not_to be nil
  end

  it 'should fetch a projects pipeline changes for an organization given a enterprise and an org' do
    pipeline = @soup.pipeline(
      organization: @organization,
      project: @project,
      pipeline: @pipeline
    )
    expect(pipeline).not_to be nil
  end

  it 'should fetch all pipeline topics' do
    topics = @soup.pipeline_topics(
      organization: @organization,
      project: @project,
      pipeline: @pipeline
    )
    expect(topics).not_to be nil
    expect(topics).not_to be_empty
  end

  it 'should fetch a pipeline topic' do
    topic = @soup.change_by_topic(
      organization: @organization,
      project: @project,
      pipeline: @pipeline,
      topic: 'foo'
    )
    expect(topic).not_to be nil
  end
end
