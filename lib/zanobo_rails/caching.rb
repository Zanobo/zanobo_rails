module ZanoboRails::Caching
  class << self

    @@INIT_RAND = rand(12384)
    @@INIT_TIME = Time.now

    def app_version_etag
      if Rails.env.development?
        "#{Random.rand()}"
      else
        "#{configuration.app_version}-#{@@INIT_RAND}"
      end
    end

    def init_time
      @@INIT_TIME
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      Rails.logger.info("running Caching configure")
      yield(configuration)
    end

  end



  class Configuration
    attr_accessor :app_version

    def initialize
      #@zanobo_some_instance_variable = true
    end
  end

end
