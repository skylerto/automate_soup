require 'ostruct'
require 'byebug'

module AutomateSoup
  ##
  # Class to represent operations on a stage.
  #
  class Stage
    def initialize(hash)
      @source = OpenStruct.new hash
    end

    def method_missing(method, *args, &block)
      @source.send(method, *args, &block)
    end

    def passed?
      @source.status.eql? 'passed'
    end

    def failed?
      @source.status.eql? 'failed'
    end
  end
end
