require 'ostruct'

module AutomateSoup
  ##
  # Class to represent operations on a change.
  #
  class Change
    def initialize(hash)
      @source = OpenStruct.new hash
    end

    ##
    # Delegate method missing to the underlying OpenStruct
    #
    def method_missing(method, *args, &block)
      @source.send(method, *args, &block)
    end

    ##
    # Determing the current stage of the change.
    # @return [AutomateSoup::Stage] the current stage.
    def current_stage
      Stage.new @source.stages.last
    end

    ##
    # Wrapper for the _links property on the struct
    #
    def links
      @source._links
    end

    ##
    # Determine if the change has been delivered successfully.
    #
    # @return [Boolean] if this change is delivered
    def delivered?
      (!current_stage.nil? &&
       current_stage.stage.eql?('delivered') &&
       current_stage.status.eql?('passed') &&
       !AutomateSoup.url.nil? &&
       !AutomateSoup.credentials.nil?)
    end

    ##
    # Determine if the change is deliverable.
    #
    # @return [Boolean] if this change is deliverable
    def deliverable?
      (!current_stage.nil? &&
       current_stage.stage.eql?('acceptance') &&
       current_stage.status.eql?('passed') &&
       !AutomateSoup.url.nil? &&
       !AutomateSoup.credentials.nil? &&
       !links.nil? &&
       !links['deliver'].nil? &&
       !links['deliver']['href'].nil?)
    end

    ##
    # Determine if the change is approvable.
    #
    # @return [Boolean] if this change is approvable
    def approvable?
      (!current_stage.nil? &&
       current_stage.stage.eql?('verify') &&
       current_stage.status.eql?('passed') &&
       !AutomateSoup.url.nil? &&
       !AutomateSoup.credentials.nil? &&
       !links.nil? &&
       !links['approve'].nil? &&
       !links['approve']['href'].nil?)
    end

    ##
    # Approve this change. Raise exceptions where applicable.
    #
    # @return [Boolean] true if the change was approved, false otherwise.
    def approve
      return nil if current_stage.stage != 'verify'
      raise 'Must run AutomateSoup.setup first' if AutomateSoup.url.nil? || AutomateSoup.credentials.nil?
      raise "Approve link not available, #{links.inspect}" if links.nil? || links['approve'].nil? || links['approve']['href'].nil?
      url = "#{AutomateSoup.url}#{links['approve']['href']}"
      res = AutomateSoup::Rest.post(
        url: url,
        username: AutomateSoup.credentials.username,
        token: AutomateSoup.credentials.token
      )
      raise "Failed to approve change: #{res.code}" if res.code != '204'
      true
    end

    ##
    # Deliver this change. Raise exceptions where applicable.
    #
    # @return [Boolean] true if the change was delivered, false otherwise.
    def deliver
      raise 'Must approve change first' if current_stage.stage.eql? 'verify'
      return nil if current_stage.stage != 'acceptance'
      raise 'Must run AutomateSoup.setup first' if AutomateSoup.url.nil? || AutomateSoup.credentials.nil?
      raise "Deliver link not available, #{links.inspect}" if links.nil? || links['deliver'].nil? || links['deliver']['href'].nil?
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
