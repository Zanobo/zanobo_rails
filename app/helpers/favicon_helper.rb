module FaviconHelper
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
  def favicon_tags(source = 'favicon.ico', options = {})
    '
      <!--[if IE]><link rel="shortcut icon" href="/favicon.ico"><![endif]-->
      <link rel="apple-touch-icon" sizes="152x152" href="/assets/img/favicons/ra-icon-152.png">
      <link rel="apple-touch-icon" sizes="144x144" href="/assets/img/favicons/ra-icon-144.png">
      <link rel="apple-touch-icon" sizes="120x120" href="/assets/img/favicons/ra-icon-120.png">
      <link rel="apple-touch-icon" sizes="114x114" href="/assets/img/favicons/ra-icon-114.png">
      <link rel="apple-touch-icon" sizes="76x76"   href="/assets/img/favicons/ra-icon-72.png">
      <link rel="apple-touch-icon" sizes="60x60"   href="/assets/img/favicons/ra-icon-60.png">
      <link rel="apple-touch-icon" sizes="57x57"   href="/assets/img/favicons/ra-icon-57.png">
      <link rel="icon" sizes="228x228" href="/assets/img/favicons/ra-icon-228.png">
      <link rel="icon" sizes="195x195" href="/assets/img/favicons/ra-icon-195.png">
      <link rel="icon" sizes="160x160" href="/assets/img/favicons/ra-icon-160.png">
      <link rel="icon" sizes="128x128" href="/assets/img/favicons/ra-icon-128.png">
      <link rel="icon" sizes="96x96"   href="/assets/img/favicons/ra-icon-96.png">
      <link rel="icon" sizes="32x32"   href="/assets/img/favicons/ra-icon-32.png">
      <meta name="application-name" content="Site Name">
      <meta name="msapplication-TileColor" content="#FFFFFF">
      <meta name="msapplication-TileImage" content="/assets/img/favicons/ra-icon-144.png">
      <meta name="msapplication-square70x70logo" content="/assets/img/favicons/ra-icon-70.png">
      <meta name="msapplication-square150x150logo" content="/assets/img/favicons/ra-icon-150.png">
      <meta name="msapplication-wide310x150logo" content="/assets/img/favicons/ra-icon-310x150.png">
      <meta name="msapplication-square310x310logo" content="/assets/img/favicons/ra-icon-310.png">
      '.html_safe
  end
end