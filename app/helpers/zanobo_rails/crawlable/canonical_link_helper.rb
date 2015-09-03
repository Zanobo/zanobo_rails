module ZanoboRails::Crawlable::CanonicalLinkHelper
  def canonical_root
    ZanoboRails::Crawlable.configuration.canonical_protocol + '://' + ZanoboRails::Crawlable.configuration.canonical_domain
  end

  def canonicalize(url)
    url.gsub( /\A(?:(?:https?:\/\/|\/\/)?[^\/]*)(\/.*)\z/,
              ZanoboRails::Crawlable.configuration.canonical_protocol + '://' + ZanoboRails::Crawlable.configuration.canonical_domain + '\1'
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