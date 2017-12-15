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
      raise "Failed to fetch orgs under enterprise #{enterprise}" unless hash['orgs']
      hash['orgs']
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
        url: "#{@soup.url}/api/v0/e/#{enterprise}/orgs/projects",
        username: @soup.credentials.username,
        token: @soup.credentials.token
      )

    rescue JSON::ParserError
      raise "Failed to fetch projects under organization #{organization} enterprise #{enterprise}"
    end
  end
end
