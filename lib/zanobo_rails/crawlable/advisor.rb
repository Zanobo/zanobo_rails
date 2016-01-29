class ZanoboRails::Crawlable::Advisor
  # Here's a bunch of best practices and rules provided by these third parties for creating their tags
  # @todo we should validate against these when saving to models, and have some checks to update existing

  # Recommendations by Crawler and Resource Type
  RECS = {
    all_crawlers: {
      all_types: {
        description: {
          sentence_count: 2
        },
        title: {}
      }
    },
    # Google Search
    google_search: {
      all_types: {
        description: {
          max_chars: 155
        },
        title: {
          max_chars: 70
        }
      }
    },
    # Google Plus
    google_plus: {
    },
    # Open Graph
    # http://ogp.me/#types
    # https://developers.facebook.com/docs/opengraph/howtos/maximizing-distribution-media-content
    og: {
      all_types: {
        description: {
          max_chars: 297
        },
        content_type: :website,
        images: {
          max_height: 375, max_width: 435,
          min_height: 600, min_width: 315,
          aspect_ratio: '1.91:1'
        },
        title: {
          max_chars: 95
        }
      },
      article: {},
      profile: {},
      website: {}
    },
    # Twitter
    # https://dev.twitter.com/docs/cards
    # "specifying the width and height using twitter:image:width and twitter:image:height helps us more accurately
    # preserve the aspect ratio of the image when resizing."
    twitter: {
      all_types: {
        description: {
          max_chars: 200,
        },
        content_type: :summary,
        images: {
          include_sizing?: true
        },
        title: {
          max_chars: 70
        }
      },
      app: {},
      gallery: {},
      photo: {
        images: {
          max_height: 375, max_width: 435,
          min_height: 150, min_width: 280
        },
      },
      player: {},
      product: {},
      summary: {
        images: {
          max_height: 375, max_width: 435,
          min_height: 120, min_width: 120,
          max_filesize: '1mb'
        },
      },
    }
  }

  # Populate recommended max for titles and descriptions as the smallest max of google, og, and twitter
  [:title,:description].each do |k|
    RECS[:all_crawlers][:all_types][k][:max_chars] = [RECS[:google_search][:all_types][k][:max_chars],
                                                      RECS[:og][:all_types][k][:max_chars],
                                                      RECS[:twitter][:all_types][k][:max_chars]].min()
  end

  # Generalized types to provide a single interface to the various content types crawlers understand


  # Recommends configuration for each crawler value based on industry/3rd party best practices
  #
  # @param query [Hash] the object and config types we're looking for as symbols, i.e.
  #   {description: :max_chars, title: :max_chars}
  # @return [Object, Array] the recommended values for each query. If there's only one, we extract it from the array
  #   before returning
  def self.recommend(query, crawler = :all_crawlers, resource_type = :all_types)
    recs = RECS[crawler][resource_type]
    values = if query.is_a?(Hash) and recs.is_a?(Hash)
               query.map do |k,v|
                 if recs.has_key? k and recs[k].has_key? v
                   recs[k][v]
                 end
               end
             elsif query.is_a?(Symbol) and recs.has_key? query
               recs[query]
             end
    values.length == 1 ? values[0] : values
  end

  # Provides a list of the types of content known by crawler
  #
  # @param crawler [Symbol] the name of the crawler
  # @return [Array] the string names of each content type
  def self.content_types_for(crawler) # was "content_types"
    if RECS.has_key?(crawler)
      RECS[crawler].keys.reject{|k| k == :all_types}.map(&:to_str)
    end
  end
end

=begin
METATAG = {
  GOOGLE: {},
  TWITTER: {},
  OG: {},
}
# Descriptions
METATAG[:GOOGLE][:DESCRIPTION] = {
  max_chars: 155
}
METATAG[:OG][:DESCRIPTION] = {
  max_chars: 297
}
METATAG[:TWITTER][:DESCRIPTION] = {
  max_chars: 200,
  min_sentences: 2
}
#Images
# https://dev.twitter.com/docs/cards/types/photo-card as of 2014-08-07
# "Specifying the width and height using twitter:image:width and twitter:image:height helps us more accurately
# preserve the aspect ratio of the image when resizing."
METATAG[:TWITTER][:IMAGES] = {}
METATAG[:TWITTER][:IMAGES][:SIZES] = {
  # https://dev.twitter.com/docs/cards/types/summary-card
  summary: {
    max_height: 375, max_width: 435,
    min_height: 120, min_width: 120,
    max_filesize: '1MB'
  },
  # https://dev.twitter.com/docs/cards/types/photo-card
  photo: {
    max_height: 375, max_width: 435,
    min_height: 150, min_width: 280
  }
}
# https://developers.facebook.com/docs/opengraph/howtos/maximizing-distribution-media-content
METATAG[:OG][:IMAGES] = {}
METATAG[:OG][:IMAGES][:SIZES] = {
  max_height: 375, max_width: 435,
  min_height: 600, min_width: 315,
  aspect_ratio: '1.91:1'
}
# Titles
METATAG[:GOOGLE][:TITLE] = {
  max_chars: 70
}
METATAG[:OG][:TITLE] = {
  max_chars: 95
}
METATAG[:TWITTER][:TITLE] = {
  max_chars: 70
}
# Types
# http://ogp.me/#types
METATAG[:OG][:CONTENT_TYPES] = {
  website: 'website',
  article: 'article',
  profile: 'profile'
}
# https://dev.twitter.com/docs/cards
METATAG[:OG][:CARDS] = {
  summary: 'summary',
  photo: 'photo',
  gallery: 'gallery',
  product: 'product',
  app: 'app',
  player: 'player'
}
=end