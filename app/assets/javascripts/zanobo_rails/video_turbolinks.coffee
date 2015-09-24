
###
 Video.js with turbolinks
 //https://github.com/seanbehan/videojs_rails

for player in document.getElementsByClassName 'video-js'
video = videojs('example_video')

before_change = ->
for player in document.getElementsByClassName 'video-js'
video = videojs('example_video')
video.dispose()

$(document).on('page:before-change', before_change)
$(document).on('page:change', change)
###