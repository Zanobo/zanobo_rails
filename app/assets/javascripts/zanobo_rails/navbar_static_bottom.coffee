navbar_static_bottom = ->
  navbar = $('.navbar-static-bottom').first()
  return if !navbar.length

  windowHeight = $(window).height()
  navbarBottom = navbar.position().top + navbar.outerHeight(true);
  changeClass = windowHeight > navbarBottom

  #console.log("navbar_static_bottom: windowHeight #{ windowHeight }" +
  #" navbarBottom #{navbarBottom} so change to fixed bottom class? #{changeClass}")

  if changeClass
    navbar.addClass('navbar-fixed-bottom')
    $('.navbar-static-bottom-spacer').addClass('navbar-fixed-bottom-spacer')


$(document).on('page:change', navbar_static_bottom)