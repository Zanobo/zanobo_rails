module ZanoboRails::Crawlable
  class << self
    attr_accessor :configuration
  end

  def self.configure
    #Rails.logger.info("running Crawlable configure")
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :canonical_protocol,
                  :canonical_domain,
                  :fb_app_id,
                  :gplus_id,
                  :page_title_sitename_pos,
                  :page_title_sitename_separator,
                  :site_name,
                  :twitter_id,
                  :twitter_related

    def initialize
      #@zanobo_some_instance_variable = true
    end

  end
end
