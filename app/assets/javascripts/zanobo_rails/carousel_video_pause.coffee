register_carousel_video_players = ->
  $('.carousel').each (index, carousel) ->
    $(carousel).find('video').each (index, video) =>
      #video_id = $(video).attr('id')
      #console.log("registering video " + $(video).attr('id') +  " on carousel " + video_id)
      $(video).on "play", ->
        #console.log("playing video" + video_id)
        $(carousel).carousel('pause')
      $(video).on "pause", ->
        #console.log("pausing video" + video_id)
        $(carousel).carousel('cycle')

$(document).on('page:change', register_carousel_video_players)