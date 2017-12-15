module AutomateSoup
  ##
  # Credentials to authenticate with chef automate
  class Credentials
    attr_reader :username, :password, :token
    def initialize(
      username: nil,
      password: nil,
      token: nil
    )
      @username = username
      @password = password
      @token = token
    end
  end
end
