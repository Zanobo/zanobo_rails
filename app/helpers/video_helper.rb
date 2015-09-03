module VideoHelper

  def contentful_videojs_tag(asset, width = nil)

    if !asset or !asset.file or
      !(content_type = asset.file.content_type) or
      !(url = asset.file.url)

      return
    end

    if content_type == 'video/webm'
      key = :webm
    elsif content_type == 'video/mp4'
      key = :mp4
    else
      return
      end

    return videojs_rails sources: { key => url }, width: width do
          'Please enable <b>JavaScript</b> to see this content.'
    end.html_safe

  end

end

