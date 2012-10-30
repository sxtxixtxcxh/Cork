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

Cork.Helpers.resetCenter =->
  $('#center').css
    left: '50%'
    top: '50%'
  $('body').css
    backgroundPositionX: 0
    backgroundPositionY: 0

class CorkRouter extends Backbone.Router
  routes:
    "": "main"
    ":board": "board"

  main: () ->
    @board()

  board: (boardSlug)->
    Session.set('boardSlug', boardSlug)
    Cork.Helpers.resetCenter()


Router = new CorkRouter()

Meteor.startup ->
  $(document).on 'click', 'header a', (e)->
    e.preventDefault()
    Router.navigate $(this).attr('href'), true

  Backbone.history.start pushState: true
