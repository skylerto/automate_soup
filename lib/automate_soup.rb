require 'automate_soup/version'
require 'automate_soup/credentials'

##
# Top level module
#
module AutomateSoup
  class << self
    def setup(
      url: nil,
      username: nil,
      token: nil,
      password: nil
    )
      @url = url
      @credentials = credentials username, token, password
    end

    private

    def credentials(username, token, password)
      return token_credentials(username, token) if token
      password_credentials(username, password) if password
    end

    def password_credentials(username, password)
      AutomateSoup::Credentials.new(
        username: username,
        password: password
      )
    end

    def token_credentials(username, token)
      AutomateSoup::Credentials.new(
        username: username,
        token: token
      )
    end
  end
end
