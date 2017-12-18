require 'ostruct'

module AutomateSoup
  ##
  # Class to represent operations on a topic.
  #
  class Topic
    def initialize(hash)
      @source = OpenStruct.new hash
    end

    def method_missing(method, *args, &block)
      @source.send(method, *args, &block)
    end
  end
end
