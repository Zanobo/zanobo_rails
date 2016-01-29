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

  # @todo Should move these to Crawlable::ContentType
  # @todo also need Crawlable::Crawlers, can contains the recomendations for each crawler, so adding crawler is as simple
  #   as adding a file and providing some hooks

  TYPES_TO_CRAWLER_CONTENT_TYPES = {
    page:    {og: :website, twitter: :summary},
    article: {og: :article, twitter: :summary},
    profile: {og: :profile, twitter: :summary},
    photo:   {og: :website, twitter: :photo  },
    gallery: {og: :website, twitter: :gallery},
    product: {og: :website, twitter: :product}
  }

  def self.general_content_types
    TYPES_TO_CRAWLER_CONTENT_TYPES.keys
  end

  def general_content_type_map(type, crawler)
    TYPES_TO_CRAWLER_CONTENT_TYPES[type][crawler]
  end

  def og_content_type_for(crawler)
    general_content_type_map(:og, crawler)
  end

  def twitter_content_type_for(crawler)
    general_content_type_map(:twitter, crawler)
  end

end

require_relative 'crawlable/advisor'
