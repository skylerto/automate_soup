require 'automate_soup/api'
require 'automate_soup/credentials'
require 'automate_soup/rest'
require 'automate_soup/version'
require 'ostruct'

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
      o = @api.status
      OpenStruct.new o
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
    # Fetch all pipelines of a project under an enterprise, organization pair
    #
    def pipelines(enterprise: 'default', organization: nil, project: nil)
      @api.pipelines(enterprise: enterprise, organization: organization, project: project)
    end

    ##
    # Fetch a pipeline of a project under an enterprise, organization pair.
    #
    def pipeline(enterprise: 'default', organization: nil, project: nil, pipeline: nil)
      arr = []
      @api.pipeline(enterprise: enterprise, organization: organization, project: project, pipeline: pipeline).each do |o|
        arr << OpenStruct.new(o)
      end
      arr
    end

    ##
    # Filters out the topics from the topics from the pipelines.
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch from.
    # @option project [String] the project to fetch from.
    # @option pipeline [String] the pipeline to fetch from.
    #
    def pipeline_topics(enterprise: 'default', organization: nil, project: nil, pipeline: nil)
      self.pipeline(
        enterprise: enterprise,
        organization: organization,
        project: project,
        pipeline: pipeline
      ).map { |p| p.topic }
    end

    ##
    # Filters out the topics from the topics from the pipelines.
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch from.
    # @option project [String] the project to fetch from.
    # @option pipeline [String] the pipeline to fetch from.
    #
    def topic(enterprise: 'default', organization: nil, project: nil, pipeline: nil, topic: nil)
      o = @api.pipeline(
        enterprise: enterprise,
        organization: organization,
        project: project,
        pipeline: pipeline
      ).select{ |p| p['topic'].eql?(topic) }.first
      OpenStruct.new o
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
