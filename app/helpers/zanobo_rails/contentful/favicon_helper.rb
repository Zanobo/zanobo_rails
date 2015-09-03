module ZanoboRails::Contentful::FaviconHelper

  # Favicon tags
  # @todo Make this respond to a source favicon file, generate images if necessary? Or somehow tie it into the pipeline
  # https://github.com/awmichel/favicon_maker_rails
  # But is there a disadvantage to listing all of these if you don't need them? Do browsers fetch the ones they don't
  # need?
  # favicons_for(@browser) in controller to restrict which we need to serve? or too many combos for cache?
  # favicons, check out github.com/audreyr/favicon-cheat-sheet & realfavicongenerator.net
  # Unfortunately chrome and Firefox download ALL of these. But everyone else dls the most appropriate.
  # https://bugzilla.mozilla.org/show_bug.cgi?id=751712
  # https://code.google.com/p/chromium/issues/detail?id=112941
  # https://code.google.com/p/chromium/issues/detail?id=324820
  # @todo enable most of these
  def favicon_tags(square, options = {})
    defaults = {
      wide_asset: nil,
      tile_color: nil,
      turbolinks: true
    }
    options.reverse_merge!(defaults)

    icons = [
=begin
      { type: :apple, square: 152 },
      { type: :apple, square: 144 },
      { type: :apple, square: 120 },
      { type: :apple, square: 114 },
      { type: :apple, square: 76 },
      { type: :apple, square: 60 },
      { type: :apple, square: 57 },
=end
      { type: :standard, square: 228 },
=begin
      { type: :standard, square: 195 },
      { type: :standard, square: 160 },
      { type: :standard, square: 128 },
      { type: :standard, square: 96 },
      { type: :ms, square: 310 },
      { type: :ms, square: 150 },
      { type: :ms, square: 70 },
      { type: :ms, width: 310, height: 150 },
      { type: :ms_tile, square: 144 },
=end
    ]

    result = ''

    icons.each do |icon|

      if icon.has_key? :square
        width = icon[:square]
        height = width
        source = square.image_url(width: width, height: height, format: 'png')
      else
        next if options[:wide_asset].blank? or
          not options[:wide_asset].respond_to? :image_url

        width = icon[:width]
        height = icon[:height]
        source = options[:wide_asset].image_url(width: width, height: height, format: 'png')
      end

      if icon[:type] == :ms_tile
        if options[:tile_color].present?
          result += favicon_tag(icon[:type], nil, nil, options[:tile_color]) + "\n"
        end
      else
        result += favicon_tag(icon[:type], width, height, source) + "\n"
      end

    end

      result.html_safe
    end

    def favicon_tag(type, height, width, source)
      element, attribute, sizes, source_attr = ''

      case type
      when :apple
        element = 'link'
        attribute = 'rel="apple-touch-icon"'
        sizes = "sizes=\"#{height}x#{width}\""
        source_attr = 'href="' + source + '"'
      when :standard
        element = 'link'
        attribute = 'rel="icon"'
        sizes = "sizes=\"#{height}x#{width}\""
        source_attr = 'href="' + source + '"'
      when :ms
        element = 'meta'
        attribute = 'name="msapplication-'
        attribute += height == width ? 'square' : 'wide'
        attribute += "#{height}x#{width}"
        attribute += 'logo"'
        source_attr = 'content="' + source + '"'
      when :ms_tile
        element = 'meta'
        attribute = 'name="msapplication-TileImage"'
        source_attr = 'content="' + source + '"'
      when :ms_tile_color
        element = 'meta'
        attribute = 'name="msapplication-TileColor"'
        source_attr = 'content="' + source + '"'
      end

      '<' + [element, attribute, sizes, source_attr].join(" ") + '>'
    end

end
