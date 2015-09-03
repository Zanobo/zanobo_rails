module Crawlable::CanonicalLinkHelper
  def canonical_root
    CRAWLER_SETTINGS[:CANONICAL_PROTOCOL] + '://' + CRAWLER_SETTINGS[:CANONICAL_DOMAIN]
  end

  def canonicalize(url)
    url.gsub( /\A(?:(?:https?:\/\/|\/\/)?[^\/]*)(\/.*)\z/,
              CRAWLER_SETTINGS[:CANONICAL_PROTOCOL] + '://' + CRAWLER_SETTINGS[:CANONICAL_DOMAIN] + '\1'
    )
  end

  #def canonical_url_for(active_object, options = {})
  #  path = if options.key? :path
  #           options[:path]
  #         else
  #           path_helper = (active_object.class.name + '_path').to_sym
  #           send(path_helper, active_object)
  #         end
  #
  #  canonical_root + path
  #end
end