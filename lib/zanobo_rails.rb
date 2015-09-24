require "zanobo_rails/engine"
require "zanobo_rails/crawlable"
require "zanobo_rails/caching"

module ZanoboRails
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :canonical_protocol,
                  :canonical_domain,


    def initialize
      @zanobo_some_instance_variable = true
    end
  end
end
