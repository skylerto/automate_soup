require 'automate_soup/api'
require 'automate_soup/credentials'
require 'automate_soup/rest'
require 'automate_soup/stage'
require 'automate_soup/change'
require 'automate_soup/version'
require 'ostruct'

##
# Top level module
#
module AutomateSoup
  class << self
    attr_accessor :url, :credentials, :api, :enterprise, :organization, :project, :pipeline

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
      password: nil,
      enterprise: 'default',
      organization: nil,
      project: nil,
      pipeline: nil
    )
      @url = url
      @credentials = if token
                       token_credentials(username, token)
                     else
                       password_credentials(username, password)
                     end
      @api = AutomateSoup::API.new(self)
      @enterprise = enterprise
      @organization = organization
      @project = project
      @pipeline = pipeline
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
    # Get the projects under and organization given the enterprise.
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch projects from.
    #
    def projects(enterprise: 'default', organization: nil)
      @api.projects(enterprise: enterprise, organization: organization)
    end

    ##
    # Fetch all project pipelines under an enterprise, organization pair
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch pipelines from.
    # @option project [String] the project to fetch pipelines from.
    #
    def pipelines(enterprise: 'default', organization: nil, project: nil)
      @api.pipelines(enterprise: enterprise, organization: organization, project: project)
    end

    ##
    # Fetch a projects pipeline under an enterprise, organization pair
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch from.
    # @option project [String] the project to fetch from.
    # @option pipeline [String] the pipeline to fetch from.
    #
    def pipeline(enterprise: 'default', organization: nil, project: nil, pipeline: nil)
      arr = []
      @api.pipeline(enterprise: enterprise, organization: organization, project: project, pipeline: pipeline).each do |o|
        arr << OpenStruct.new(o)
      end
      arr
    end

    ##
    # Filters out the topics from the pipelines changes .
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch from.
    # @option project [String] the project to fetch from.
    # @option pipeline [String] the pipeline to fetch from.
    #
    # @return [Array] an array of strings holding change topics.
    def pipeline_topics(enterprise: 'default', organization: nil, project: nil, pipeline: nil)
      self.pipeline(
        enterprise: enterprise,
        organization: organization,
        project: project,
        pipeline: pipeline
      ).map { |p| p.topic }
    end

    ##
    # Find a change by topic.
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch from.
    # @option project [String] the project to fetch from.
    # @option pipeline [String] the pipeline to fetch from.
    # @option topic [String] the topic to fetch a change from.
    #
    # @return [AutomateSoup::Change] the change coresponding to the given topic.
    def change_by_topic(enterprise: @enterprise, organization: @organization, project: @project, pipeline: @pipeline, topic: nil)
      o = self.pipeline(
        enterprise: enterprise,
        organization: organization,
        project: project,
        pipeline: pipeline
      ).select { |p| p.topic.eql?(topic) }
      first = o.first
      raise "Cannot find topic #{topic} in #{o}" if first.nil?
      AutomateSoup::Change.new first
    end

    ##
    # Approve a change by change topic.
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch from.
    # @option project [String] the project to fetch from.
    # @option pipeline [String] the pipeline to fetch from.
    # @option topic [String] the change topic to approve
    # @option wait [Boolean] to wait for the approval stages to complete.
    # @option timeout [Integer] the time in seconds to wait between requests defaults
    # to 10
    # @option retries [Integer] the amount of retries to make, defaults to 5
    #
    # @return [Boolean] true if the change was approved, false otherwise.
    def approve_change(enterprise: @enterprise, organization: @organization, project: @project, pipeline: @pipeline, topic: nil, wait: false, timeout: 10, retries: 5)
      o = self.change_by_topic(
        enterprise: enterprise,
        organization: organization,
        project: project,
        pipeline: pipeline,
        topic: topic
      )

      return true if !o.nil? && o.delivered?

      if wait && !o.approvable? && !o.deliverable?
        times = 1
        while times <= retries
          o = self.change_by_topic(
            enterprise: enterprise,
            organization: organization,
            project: project,
            pipeline: pipeline,
            topic: topic
          )
          break if o.approvable?
          return false if o.current_stage.failed?
          puts "Stage #{o.current_stage.stage}: #{o.current_stage.status} retries #{times}/#{retries}"
          sleep timeout
          times += 1
        end
      end

      app = o.approve
      return true if !wait && !app.nil? && o.deliverable?
      if app.nil? && !o.deliverable?
        puts "Could not approve change #{o.current_stage.stage}: #{o.current_stage.status}"
        return false
      end

      times = 1
      while times <= retries
        o = self.change_by_topic(
          enterprise: enterprise,
          organization: organization,
          project: project,
          pipeline: pipeline,
          topic: topic
        )
        break if o.deliverable?
        return false if o.current_stage.failed?
        puts "Stage #{o.current_stage.stage}: #{o.current_stage.status} retries #{times}/#{retries}"
        times += 1
        sleep timeout
      end
      true
    end


    ##
    # Delivery a change by a topic
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch from.
    # @option project [String] the project to fetch from.
    # @option pipeline [String] the pipeline to fetch from.
    # @option topic [String] the change topic to approve
    # @option wait [Boolean] to wait for the approval stages to complete.
    # @option timeout [Integer] the time in seconds to wait between requests defaults
    # to 10
    # @option retries [Integer] the amount of retries to make, defaults to 5
    #
    # @return [Boolean] true if the change was delivered, false otherwise.
    def deliver_change(enterprise: @enterprise, organization: @organization, project: @project, pipeline: @pipeline, topic: nil, wait: false, timeout: 10, retries: 5)
      o = self.change_by_topic(
        enterprise: enterprise,
        organization: organization,
        project: project,
        pipeline: pipeline,
        topic: topic
      )
      return false if !o.deliverable?
      if wait && !o.deliverable?
        times = 1
        while times <= retries
          o = self.change_by_topic(
            enterprise: enterprise,
            organization: organization,
            project: project,
            pipeline: pipeline,
            topic: topic
          )
          break if o.deliverable?
          return false if o.current_stage.failed?
          puts "Stage #{o.current_stage.stage}: #{o.current_stage.status} retries #{times}/#{retries}"
          sleep timeout
          times += 1
        end
      end

      de = o.deliver
      return true if !wait && !de.nil? && o.delivered?

      if de.nil? && !o.deliverable?
        puts "Could not deliver change #{o.current_stage.stage}: #{o.current_stage.status}"
        return false
      end

      times = 1
      while times <= retries
        o = self.change_by_topic(
          enterprise: enterprise,
          organization: organization,
          project: project,
          pipeline: pipeline,
          topic: topic
        )
        break if o.delivered?
        return false if o.current_stage.failed?
        puts "Stage #{o.current_stage.stage}: #{o.current_stage.status} retries #{times}/#{retries}"
        times += 1
        sleep timeout
      end
      true
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
