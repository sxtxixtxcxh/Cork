Cork.Helpers.addExternalFavicon = (context)->
  context ||= document
  return if $(context).hasClass('image')
  return if $(context).hasClass('youtube')
  $("a[href^='http']", context).each ->
    $(this).css
      background: "url(http://www.google.com/s2/u/0/favicons?domain=#{@hostname}) left center no-repeat",
      "padding-left": "20px"
