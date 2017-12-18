module AutomateSoup
  ##
  # API class to interact with chef automate
  class API
    def initialize(soup)
      @soup = soup
    end

    ##
    # Get the status of the Automate API
    #
    def status
      AutomateSoup::Rest.get(
        url: "#{@soup.url}/api/_status",
        username: @soup.credentials.username,
        token: @soup.credentials.token
      )
    end

    ##
    # Get the organizations given the enterprise.
    #
    # @param enterprise [String] the enterprise to fetch orgs from, defaults to
    # default.
    #
    def orgs(enterprise = 'default')
      @hash = AutomateSoup::Rest.get(
        url: "#{@soup.url}/api/v0/e/#{enterprise}/orgs",
        username: @soup.credentials.username,
        token: @soup.credentials.token
      )
      raise "Failed to fetch orgs under enterprise #{enterprise}" unless @hash['orgs']
      @hash['orgs']
    end

    ##
    # Get the projects under and organization given the enterprise.
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch projects from.
    #
    def projects(enterprise: 'default', organization: nil)
      @hash = AutomateSoup::Rest.get(
        url: "#{@soup.url}/api/v0/e/#{enterprise}/orgs/#{organization}/projects",
        username: @soup.credentials.username,
        token: @soup.credentials.token
      )

    rescue JSON::ParserError
      raise "Failed to fetch projects under organization #{organization} enterprise #{enterprise}"
    end

    ##
    # Fetch a project under an enterprise, organization pair
    #
    # @option enterprise [String] the enterprise to fetch org from, defaults to
    # default.
    # @option organization [String] the organization to fetch projects from.
    # @option project [String] the organization to fetch projects from.
    #
    def project(enterprise: 'default', organization: nil, project: nil)
      @hash = AutomateSoup::Rest.get(
        url: "#{@soup.url}/api/v0/e/#{enterprise}/orgs/#{organization}/projects/#{project}/pipelines",
        username: @soup.credentials.username,
        token: @soup.credentials.token
      )

    rescue JSON::ParserError
      raise "Failed to fetch projects under organization #{organization} enterprise #{enterprise}"
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
      @hash = AutomateSoup::Rest.get(
        url: "#{@soup.url}/api/v0/e/#{enterprise}/orgs/#{organization}/projects/#{project}/pipelines",
        username: @soup.credentials.username,
        token: @soup.credentials.token
      )
      @hash['pipelines']

    rescue JSON::ParserError
      raise "Failed to fetch pipelines under organization #{organization} enterprise #{enterprise}"
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
      @hash = AutomateSoup::Rest.get(
        url: "#{@soup.url}/api/v0/e/#{enterprise}/orgs/#{organization}/projects/#{project}/changes?pipeline=#{pipeline}&limit=25",
        username: @soup.credentials.username,
        token: @soup.credentials.token
      )
    rescue JSON::ParserError
      raise "Failed to fetch pipelines under organization #{organization} enterprise #{enterprise}"
    end
  end
end
