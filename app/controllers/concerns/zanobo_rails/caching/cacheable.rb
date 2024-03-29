module ZanoboRails::Caching::Cacheable
  extend ActiveSupport::Concern

  included do
    before_filter :init_cache_metadata

    def cache_key
      cache_key_parts.join('-')
    end

    alias_method :etag, :cache_key

    def last_modified
      @cache_modified_times.max
    end

    def modified_with(*records)
      @cache_modified_times += records.flatten.compact.map(&:updated_at).compact

      # I THINK having last_modified in the cache key should be sufficient
      #@cache_key_parts += records_cache_keys
    end

    def cache_keyed_with(object)
      object.to_s # ensure this won't fail
      cache_key_parts += object
    end

    def app_version_etag
      ZanoboRails::Caching.app_version_etag
      #Rails.logger.info("getting app_Version_etag")
    end

    def cache_key_parts
      [controller_name, action_name, last_modified, app_version_etag] + @cache_key_parts
    end

    def modified_times
      @cache_modified_times
    end

  end



  def init_cache_metadata
    @cache_modified_times = [ZanoboRails::Caching.init_time]
    @cache_key_parts = []
  end


end