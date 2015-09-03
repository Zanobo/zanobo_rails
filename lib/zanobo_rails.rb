require "zanobo_rails/engine"

module ZanoboRails
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :config_option_1,
                  :config_option_2

    def initialize
      @zanobo_some_instance_variable = true
    end
  end
end
