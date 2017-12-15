require 'net/http'
require 'json'
require 'openssl'
require 'uri'

module AutomateSoup
  ##
  # Rest class for making HTTP requests
  module Rest
    class << self
      def get(url: nil, username: nil, token: nil)
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = ::OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri.request_uri)
        request = auth_request request, username, token
        res = http.request(request)
        JSON.parse(res.body)
      end

      def auth_request(request, user, token)
        request.add_field('chef-delivery-user', user)
        request.add_field('chef-delivery-token', token)
        request
      end
    end
  end
end
