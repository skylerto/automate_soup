require 'spec_helper'

RSpec.describe AutomateSoup::Credentials do
  it 'creates credentials with username/password' do
    creds = AutomateSoup::Credentials.new(
      username: 'test',
      password: 'test'
    )
    expect(creds).not_to be nil
  end

  it 'creates credentials with username/token' do
    creds = AutomateSoup::Credentials.new(
      username: 'test',
      token: 'test'
    )
    expect(creds).not_to be nil
  end
end
