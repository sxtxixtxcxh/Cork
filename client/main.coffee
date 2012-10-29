Meteor.subscribe 'users'

Cork.Helpers =
  addExternalFavicon: (context)->
    context ||= document
    return if $(context).hasClass('image')
    $("a[href^='http']", context).each ->
      $(this).css
        background: "url(http://www.google.com/s2/u/0/favicons?domain=#{@hostname}) left center no-repeat",
        "padding-left": "20px"
  detectType: (content)->
    $link = $('<a>').attr('href', content)
    url = $link[0]
    path = url.pathname.toLowerCase()
    image = path.match(/.jpg$|.jpeg$|.png$|.gif$/)
    if image?.length > 0 and content is url.href
      return 'image'
    youtube = url.hostname.match(/.youtube.com/)
    if youtube?.length > 0 and content is url.href
      return 'youtube'

    return 'post'
