require 'meta-tags'

module ZanoboRails::Crawlable::MetaTagsHelper

  # application_meta_tags
  # Brings together all the meta tags you might need, for inclusion in your layout
  def application_meta_tags
    tags = ''.html_safe

    # These include the content encoding = UTF-8 tag, which is helpful to have first in a few rare occasions
    tags << boiler_plate_meta_tags

    # Pass regular tags to the meta-tags gem (only works for meta name=, content= )
    set_site_meta_tags
    set_locale_meta_tags

    # content meta tags are set in view or controller using concerns/crawlable/serves_metatags#set_meta_tags_for,
    #  then aggregated with the above set_ commands and displayed by display_meta_tags
    tags << display_meta_tags

    # Rails built-in Cross Site Scripting protection tags
    # Leave this out of the above for best forward compatibility
    tags << csrf_meta_tags

    tags
  end

  private

  # Adds tags that have become standard to all HTML documents
  def boiler_plate_meta_tags
    # read document as encoded in UTF-8
    ('<meta charset="utf-8">' + "\n" +
    # tell IE to use the latest version to render, this is default in IE11+
    '<meta http-equiv="X-UA-Compatible" content="IE=edge">' + "\n" +
    # set window to normal scale and width
    '<meta name="viewport" content="width=device-width, initial-scale=1">').html_safe
  end

  # Identify site to social services
  def set_site_meta_tags
    config = ZanoboRails::Crawlable.configuration

    site_ids = {
      separator: config.page_title_sitename_separator,
      reverse: config.page_title_sitename_pos == 'right'
    }

    if config.gplus_id.present?
      site_ids[:publisher] = "https://plus.google.com/#{config.gplus_id}"
    end
    if config.twitter_id.present?
      site_ids[:twitter] = "@#{config.twitter_id}"
    end
    if config.fb_app_id.present?
      site_ids[:fb] = { app_id: "@#{config.fb_app_id}" }
    end
    if config.site_name.present?
      site_ids[:open_graph] = { site_name: config.site_name }
      site_ids[:site] = config.site_name
    end

    set_meta_tags(site_ids)
  end

  # Give info on current locale and other options
  def set_locale_meta_tags
    set_meta_tags(og: {locale: t('locale.short-code', default: 'en_US')} )
    # @todo When we support multiple locales, pull them in below
    #alternate: { "fr" => "http://yoursite.fr/alternate/url",
    #             "de" => "http://yoursite.de/alternate/url" }
  end

end