autostart_carousels = ->
  $('.carousel').carousel({
    interval: 5000,
    pause: 'false'
  })

$(document).on('page:change', autostart_carousels)