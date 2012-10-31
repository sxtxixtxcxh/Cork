Meteor.subscribe 'users'

Cork.Helpers =
  addExternalFavicon: (context)->
    context ||= document
    return if $(context).hasClass('image')
    return if $(context).hasClass('youtube')
    $("a[href^='http']", context).each ->
      $(this).css
        background: "url(http://www.google.com/s2/u/0/favicons?domain=#{@hostname}) left center no-repeat",
        "padding-left": "20px"

  detectMedia: (content)->
    lines = content.split("\n")
    tokens = _.flatten _.map lines, (item)->
      item.split(' ')
    type = undefined
    _.find tokens, (item, i)->
      url = $('<a>').attr('href', item)[0]
      path = url.pathname.toLowerCase()
      if path.match(/.jpg$|.jpeg$|.png$|.gif$/)
        type = {type: 'image', mediaUrl: url.href}
        return true
      if url.hostname.match(/youtube.com/)
        type = {type: 'youtube', mediaUrl: url.href}
        return true
    type ||= {type: 'post', mediaUrl: undefined}
    return type

  queryStringToObject: (queryString)->
    params = queryString.split('&')
    queryObject = {}
    _.each params, (item, index)->
      keyValuePair = item.split('=')
      queryObject[keyValuePair[0].replace(/^\?/, '')] = keyValuePair[1]
    queryObject

  resetCenter: ->
    $('#center').css
      left: '50%'
      top: '50%'
    $('body').css
      backgroundPositionX: 0
      backgroundPositionY: 0

class CorkRouter extends Backbone.Router
  routes:
    "": "main"
    "home": "myBoard"
    "users/:slug": "showUsersBoard"
    "boards/:board": "showBoard"

  main: ()->
    @showBoard()

  myBoard: ()->
    if Meteor.user() and Meteor.userLoaded()
      @showUsersBoard(Meteor.user().profile.slug)
    else
      # figure out what to do until the user is loaded
      @navigate('/', true)

  showUsersBoard: (slug)->
    @showBoard("user-#{slug}")

  showBoard: (boardSlug)->
    Session.set('boardSlug', boardSlug)
    Cork.Helpers.resetCenter()


Router = new CorkRouter()

Meteor.startup ->
  $(document).on 'click', 'header a[href^=/]', (e)->
    e.preventDefault()
    Router.navigate $(this).attr('href'), true

  Backbone.history.start pushState: true
