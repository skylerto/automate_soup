require 'spec_helper'

RSpec.describe AutomateSoup do
  it 'has a version number' do
    expect(AutomateSoup::VERSION).not_to be nil
  end

  it 'creates a new instance of AutomateSoup with password' do
    soup = AutomateSoup.setup(
      url: 'test',
      username: 'test',
      password: 'test'
    )
    expect(soup).not_to be nil
  end

  it 'creates a new instance of AutomateSoup with token' do
    soup = AutomateSoup.setup(
      url: 'test',
      username: 'test',
      token: 'test'
    )
    expect(soup).not_to be nil
  end
end
