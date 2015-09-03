module Crawlable::MetaTagsHelper
  # application_meta_tags
  # Brings together all the meta tags you might need, for inclusion in your layout
  def application_meta_tags
    tags = ''.html_safe

    # These include the content encoding = UTF-8 tag, which is helpful to have first in a few rare occasions
    tags << boiler_plate_meta_tags

    # Pass the favicon links in early so the image loading can start
    tags << favicon_tags

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
    set_meta_tags( publisher:
                     (CRAWLER_SETTINGS[:GPLUS_ID] ? "https://plus.google.com/#{CRAWLER_SETTINGS[:GPLUS_ID]}" : nil),
                   twitter: {site:
                     (CRAWLER_SETTINGS[:TWITTER_ID] ? "@#{CRAWLER_SETTINGS[:TWITTER_ID]}" : nil )},
                   fb: {app_id:
                     CRAWLER_SETTINGS[:FB_APP_ID]},
                   open_graph: { :site_name => CRAWLER_SETTINGS[:SITE_NAME] },
                   separator:
                     CRAWLER_SETTINGS[:PAGE_TITLE_SITENAME_SEPARATOR],
                   reverse:
                     (CRAWLER_SETTINGS[:PAGE_TITLE_SITENAME_POS] == 'right'),
                   site: CRAWLER_SETTINGS[:SITE_NAME],
    )
  end

  # Give info on current locale and other options
  def set_locale_meta_tags
    set_meta_tags(og: {locale: t('locale.short-code')}
                  # @todo When we support multiple locales, pull them in below
                  #alternate: { "fr" => "http://yoursite.fr/alternate/url",
                  #             "de" => "http://yoursite.de/alternate/url" }
    )
  end

end