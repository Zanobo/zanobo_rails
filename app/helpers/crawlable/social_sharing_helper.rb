module Crawlable::SocialSharingHelper

  # Retrive the share url for a model, taking into account its class legacy url rules and possible custom routing
  # @todo Abstract social share URL definition from document
  def social_share_url_for(model, options = {})
    if not (legacy_url = SocialSharing.legacy_url_for(model)).blank?
      legacy_url
    elsif (custom_helper = options[:path_helper].to_sym)
      Crawlable.canonical_root + self.send(custom_helper, model)
    else
      Crawlable.canonical_root + self.send(:"#{model.class.name}_path", model)
    end
  end
end