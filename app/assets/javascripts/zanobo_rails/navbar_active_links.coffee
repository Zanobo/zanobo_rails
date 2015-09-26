mark_active_links = ->
  current_path = window.location.pathname
  $('.navbar .nav li').each (index, li) ->
    $(li).find('a').each (index, a) =>
      href = $(a).attr('href')
      if current_path == href
        $(li).addClass('active')

$(document).on('page:change', mark_active_links)