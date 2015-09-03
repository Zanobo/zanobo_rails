module Crawlable::ServesMetatags
  extend ActiveSupport::Concern

  # https://www.iacquire.com/blog/18-meta-tags-every-webpage-should-have-in-2013
  # Many ways to use this:
  # You could set meta tags in controller or view with set_meta_tags
  # :this => value, each manually, for most control
  # If you have simplified your metatag values to the inputs for prepare, you
  # can prepare_meta_tags :simpler => value
  # If you move this hash to your model under meta_tag_hash,
  # you can meta_tags_for @object
  # Finally, if all your meta tags are stored with correct simplified names
  # and properties, you can do that without
  #  putting anything in your model besides your meta_tag association

=begin
  @todo Include tags, publish time, modify time
  <meta property="article:published_time" content="2012-11-20T22:31:41+00:00">
  <meta property="article:modified_time" content="2012-11-22T20:24:26+00:00">
  <meta property="article:author" content="http://example.com/author/name/">
  <meta property="article:section" content="section name">
  <meta property="article:tag" content="tag name">
=end

  class MetaTagError < StandardError

  end

  included do
    # @todo Exposing set_meta_tags_for as a view helper doesn't actually set
    #   tags for display_meta_tags
    #helper_method :set_meta_tags_for #, :prepare_meta_tags

    # Set Meta Tags to those provided by a "Crawlable" object
    def set_meta_tags_for(tagged_object, options = {})
      defaults = {
      #  url: url_for(tagged_object)  # Not working for dynamic pages,
      # needs activemodel? Needs #model_name
        url: CRAWLER_SETTINGS[:CANONICAL_PROTOCOL] + '://' +
          CRAWLER_SETTINGS[:CANONICAL_DOMAIN] + request.path
      }

      options.reverse_merge! defaults

      if tagged_object.respond_to? :meta_tags_hash
        object_meta_hash = tagged_object.meta_tags_hash
        object_meta_hash.reverse_merge! options
        prepared_tags = prepare_meta_tags(object_meta_hash)

        set_meta_tags prepared_tags

        #@todo Catch title and description for use in rss/atom builders
        #  the below is not working for some reason
        #@page_title = prepared_tags.inspect
        #@page_description = prepared_tags[:description]
        #@flash[:error] = prepared_tags
      else
        #@flash[:error] = 'no meta tag function found'
      end
    end

    # Prepare_Meta_Tags
    #  Takes a nice abstraction of the info about this content and turns it
    # into meta tag values for spiders
    #  Output is in the generalized meta tag format that the meta-tags gem uses
    # @todo Support google plus targeting! Not support by meta-tags gem.... grrr
    def prepare_meta_tags(options = {})
      defaults =  {
        author: nil,
        authors: [],
        description: nil,
        description_og: nil,
        description_twitter: nil,
        images: [],
        #is_duplicate?: false,
        # # used to determine if we should rel=canonical, true if viewing a paginated
        # just comparing request url to canonical for now
        # form of a full-page-enabled resource
        keywords: [],
        nofollow?: false,
        noindex?: false,
        page: nil,                          # Have to throw this into the title
        pages: nil,                         #  along with this
        title: nil,                         # Just the descriptive part of the title
        #title_format: nil,                 # Title with placeholders for sitename, pages, and separators
        # disabling this for now, because getting it to with with meta-tags
        # current title passing scheme would require reading placement and
        # then monkey-patching parameters
        #title_separator: '|',              #set this at higher level # '-', 'on', ':', etc
        #title_site_name_position: 'right', #set this at higher level
        #title_site_name: SITE_IDS[:NAME],  # provided earlier on, meta-tags ties to other site identifier tags
        title_og: nil,
        title_twitter: nil,
        type: 'page',                      # og and twitter need types, we generate from our map if missing
        type_og: nil,
        type_twitter: nil,
        video: nil,
        url: nil,                          # canonical, required by og "#{request.url}"
        url_current: request.url,
        url_next: nil,                     # if paged and no full-page alternative
        url_prev: nil,                     # if paged and no full-page alternative
      }
      options.reverse_merge! defaults

      # @todo Raise some errors if mandatory things are missing as required by
      # og and twitter, i.e.
      # We want this to fill out as much as possible, but it needs a base of info
      # description
      # title (except certain cards...)
      # url - this is the big one, always needed
      # image_url - for og
      if options[:url].blank?
        raise MetaTagError, 'No url defined for content, required by OG and needed if protocol different from canonical'
      end


      # initialize return array
      return_values = {
        author: [],
        og: { image: []},
        twitter: { creator: []}
      }

      # Authors
      options[:authors] << options[:author] if options[:author]
      options[:authors].each do |author|
        if author.has_key?(:gplus_id) and (id = author[:gplus_id])
          return_values[:author] << "https://plus.google.com/#{id}"
        end
        if author.has_key?(:twitter_id)
          return_values[:twitter][:creator] << id
        end
      end

      # Descriptions
      return_values[:description] = options[:description]
      return_values[:og][:description] = options[:description_og]
      return_values[:twitter][:description] = options[:description_twitter]

      # Images
      # @todo existence checks and warnings for sizes, AR, filesize, etc
      # @todo Need to take in all images and distribute to each stream according to size appropriateness,
      #   unless specifically tagged to a stream

      # Images - OG
      # @todo pass https url through secure_url, width and height once after
      #   https://github.com/kpumuk/meta-tags/issues/63 is resolved
      options[:images].each do |image|
        if image.has_key? :url
          return_values[:og][:image] << image[:url]

          #if image.has_key? :width and image.has_key? :height
          #  return_values[:og][:image][:width] = image[:width].to_i
          #  return_values[:og][:image][:height] = image[:height].to_i
          #end
        end
      end

      # Images - Twitter
      # Falls back to open graph, let's rely on that for now
      # @todo Support custom images for twitter

      # Keywords
      return_values[:keywords] = options[:keywords]

      # Noindex, nofollow
      # @todo Build in checking for if these are turned off for this object type somewhere
      return_values[:noindex] = options[:noindex?]
      return_values[:nofollow] = options[:nofollow?]

      # Titles
      return_values[:og][:title] = options[:title_og] if options[:title_og]
      return_values[:twitter][:title] = options[:title_twitter] if options[:title_twitter]

      #if options.has_key)[:title_format]
      #  #if options[:title_page_format]
      #
      #  end
      #  return_values[:title] = options[:title_format].gsub(['special','characters'],['value','otherval'])
      #else
      if options[:pages] and options[:page] and options[:pages] > 1 and options[:page] > 1
        return_values[:title] = [
          options[:title],
          t('pagination.page_x_of_y', page: options[:page], pages: options[:pages])
        ]
      else
        return_values[:title] = options[:title]
      end
      #end

      # Types
      og_content_type = options[:type_og]
      if og_content_type and Crawlable.content_types_for(:og).include? og_content_type
        return_values[:og][:type] = og_content_type
      elsif type_provided = (general_type = options[:type] and Crawlable.general_content_types.include? general_type)
        return_values[:og][:type] = Crawlable::Advisor.og_content_type_for(general_type)
      else
        # Type is REQUIRED, we really should test for required values.
        return_values[:og][:type] = Crawlable::Advisor.recommend(:content_type, :og).to_s
      end

      twitter_content_type = options[:type_twitter]
      if twitter_content_type and Crawlable.content_types_for(:twitter).include? twitter_content_type
        return_values[:twitter][:type] = twitter_content_type
      elsif type_provided
        return_values[:twitter][:type] = Crawlable.twitter_content_type_for(general_type)
      else
        # Type is REQUIRED
         return_values[:twitter][:type] = Crawlable::Advisor.recommend(:content_type, :twitter).to_s
      end

      # URLS
      # og:url
      # twitter:url
      # rel=canonical
      return_values[:og][:url] = options[:url]
      return_values[:twitter][:url] = options[:url]
      return_values[:canonical] = options[:url] unless request.url == options[:url]
      return_values[:next] = options[:url_next]
      return_values[:prev] = options[:url_prev]

      # Video
      #og:video    => {
      #  :director => 'http://www.imdb.com/name/nm0000881/',
      #  :writer   => ['http://www.imdb.com/name/nm0918711/', 'http://www.imdb.com/name/nm0177018/']
      #}

      # Tell og and twitter to use primary description and title if nothing is customized to them
      return_values[:og][:description] = :description if return_values[:og][:description].nil?
      return_values[:twitter][:description] = :description if return_values[:twitter][:description].nil?
      return_values[:og][:title] = :title if return_values[:og][:title].nil?
      return_values[:twitter][:title] = :title if return_values[:twitter][:title].nil?

      return_values
    end

  end
end
