Meteor.subscribe 'users'

Cork.Helpers.addExternalFavicon = (context)->
  context ||= document
  $("a[href^='http']", context).each ->
    $(this).css
      background: "url(http://www.google.com/s2/u/0/favicons?domain=#{@hostname}) left center no-repeat",
      "padding-left": "20px"
