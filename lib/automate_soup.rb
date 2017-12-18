require 'automate_soup/api'
require 'automate_soup/credentials'
require 'automate_soup/rest'
require 'automate_soup/version'

##
# Top level module
#
module AutomateSoup
  class << self
    attr_accessor :url, :credentials

    ##
    # Setup Automate Soup client.
    #
    # @option url [String] The Chef Automate URL.
    # @option username [String] The Chef Automate username.
    # @option token [String] The Chef Automate user token.
    # @option password [String] The Chef Automate user password.
    #
    def setup(
      url: nil,
      username: nil,
      token: nil,
      password: nil
    )
      @url = url
      @credentials = if token
                       token_credentials(username, token)
                     else
                       password_credentials(username, password)
                     end
      @api = AutomateSoup::API.new(self)
      self
    end

    ##
    # Check the status of Automate
    #
    def status
      @api.status
    end

    ##
    # Fetch all organizations under an enterprise
    #
    def orgs(enterprise = 'default')
      @api.orgs enterprise
    end

    ##
    # Fetch all projects under an enterprise, organization pair
    #
    def projects(enterprise: 'default', organization: nil)
      @api.projects(enterprise: enterprise, organization: organization)
    end

    ##
    # Fetch a project under an enterprise, organization pair
    #
    def project(enterprise: 'default', organization: nil, project: nil)
      @api.project(enterprise: enterprise, organization: organization, project: project)
    end

    private

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
