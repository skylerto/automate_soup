module AutomateSoup
  ##
  # API class to interact with chef automate
  class API
    def initialize(soup)
      @soup = soup
    end

    def status
      AutomateSoup::Rest.get(
        url: "#{@soup.url}/api/_status",
        username: @soup.credentials.username,
        token: @soup.credentials.token
      )
    end
  end
end
