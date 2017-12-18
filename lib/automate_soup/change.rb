require 'ostruct'

module AutomateSoup
  ##
  # Class to represent operations on a change.
  #
  class Change
    def initialize(hash)
      @source = OpenStruct.new hash
    end

    def method_missing(method, *args, &block)
      @source.send(method, *args, &block)
    end

    def current_stage
      Stage.new @source.stages.last
    end

    def links
      @source._links
    end

    def delivered?
      (current_stage.stage.eql?('delivered') &&
        current_stage.status.eql?('passed') &&
        !AutomateSoup.url.nil? &&
        !AutomateSoup.credentials.nil?)
    end

    def deliverable?
      (current_stage.stage.eql?('acceptance') &&
        current_stage.status.eql?('passed') &&
        !AutomateSoup.url.nil? &&
        !AutomateSoup.credentials.nil? &&
        !links.nil? &&
        !links['deliver'].nil? &&
        !links['deliver']['href'].nil?)
    end

    def approvable?
      (current_stage.stage.eql?('verify') &&
        current_stage.status.eql?('passed') &&
        !AutomateSoup.url.nil? &&
        !AutomateSoup.credentials.nil? &&
        !links.nil? &&
        !links['approve'].nil? &&
        !links['approve']['href'].nil?)
    end

    def approve
      return nil if current_stage.stage != 'verify'
      raise 'Must run AutomateSoup.setup first' if AutomateSoup.url.nil? || AutomateSoup.credentials.nil?
      raise 'Approve link not available' if links.nil? || links['approve'].nil? || links['approve']['href'].nil?
      url = "#{AutomateSoup.url}#{links['approve']['href']}"
      res = AutomateSoup::Rest.post(
        url: url,
        username: AutomateSoup.credentials.username,
        token: AutomateSoup.credentials.token
      )
      raise "Failed to approve change: #{res.code}" if res.code != '204'
      true
    end

    def deliver
      raise 'Must approve change first' if current_stage.stage.eql? 'verify'
      return nil if current_stage.stage != 'acceptance'
      raise 'Must run AutomateSoup.setup first' if AutomateSoup.url.nil? || AutomateSoup.credentials.nil?
      raise 'Deliver link not available' if links.nil? || links['deliver'].nil? || links['deliver']['href'].nil?
      url = "#{AutomateSoup.url}#{links['deliver']['href']}"
      res = AutomateSoup::Rest.post(
        url: url,
        username: AutomateSoup.credentials.username,
        token: AutomateSoup.credentials.token
      )
      raise "Failed to deliver change: #{res.code}" if res.code != '204'
      true
    end
  end
end
