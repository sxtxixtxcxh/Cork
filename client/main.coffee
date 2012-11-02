Meteor.subscribe 'users'

Cork.Helpers =
  checkUrl: ->
    unless window.location.hash is Cork.coordHash
      Cork.coordHash = window.location.hash
      Cork.Helpers.centerBoard()

  bodyBgAndCenterStart: ($body, $center)->
    bgPos = $body.css('backgroundPosition').split(' ')
    bgX = parseInt bgPos[0], 10
    bgY = parseInt bgPos[1], 10
    centerStartX = $center.position().left
    centerStartY = $center.position().top
    return {
      center:
        x: centerStartX
        y: centerStartY
      bg:
        x: bgX
        y: bgY
    }

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

  centerBoard: ->
    $center = $('#center')
    $body = $('body')
    position = Cork.Helpers.bodyBgAndCenterStart($body, $center)
    coords = Cork.coordHash.replace(/#/,'')
    if coords.match(/x:\d+|y:\d+/)
      console.log coords
      coords = coords.split(';')
      center = _.map coords, (item)->
        coord = item.split(':')
        position.center[coord[0]] = coord[1]
        position.bg[coord[0]] = coord[1]
      center=
        $el: $center
        x: "#{position.center.x}px"
        y: "#{position.center.y}px"
      bg=
        $el: $body
        x: position.bg.x
        y: position.bg.y
      $body.addClass('transition')
      $center.addClass('transition')
      setTimeout(->
        $body.removeClass('transition')
        $center.removeClass('transition')
      , 300)

      Cork.Helpers.pan center, bg

  slide: (direction, speed)->
    $body = $('body')
    return if $body.hasClass('transition')
    $center = $('#center')
    speed ||= 1
    dist = 10 * speed
    $body.addClass('transition')
    $center.addClass('transition')
    setTimeout(->
      $body.removeClass('transition')
      $center.removeClass('transition')
    , 300)
    position = Cork.Helpers.bodyBgAndCenterStart($body, $center)

    switch direction
      when 'left'
        position.center.x += dist
        position.bg.x += dist
      when 'right'
        position.center.x -= dist
        position.bg.x -= dist
      when 'up'
        position.center.y += dist
        position.bg.y += dist
      when 'down'
        position.center.y -= dist
        position.bg.y -= dist

    Cork.Helpers.pan
      $el: $center
      x: position.center.x
      y: position.center.y
    ,
      $el: $body
      x: position.bg.x
      y: position.bg.y

  pan: (center, bg)->
    center.$el.css
      left: center.x
      top: center.y
    bg.$el.css 'backgroundPosition', "#{bg.x}px #{bg.y}px"

    console.log center.$el, center.x, center.y, bg.x, bg.y
class CorkRouter extends Backbone.Router
  routes:
    "/": "main"
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
    Cork.Helpers.centerBoard()



Router = new CorkRouter()

Meteor.startup ->
  Mousetrap.bind ['shift+left', 'command+left', 'ctrl+left'], ->
    Cork.Helpers.slide('left', 5)
  Mousetrap.bind ['shift+right', 'command+righ', 'ctrl+right'], ->
    Cork.Helpers.slide('right', 5)
  Mousetrap.bind ['shift+up', 'command+up', 'ctrl+up'], ->
    Cork.Helpers.slide('up', 5)
  Mousetrap.bind ['shift+down', 'command+down', 'ctrl+down'], ->
    Cork.Helpers.slide('down', 5)

  Mousetrap.bind 'left', ->
    Cork.Helpers.slide('left')
  Mousetrap.bind 'right', ->
    Cork.Helpers.slide('right')
  Mousetrap.bind 'up', ->
    Cork.Helpers.slide('up')
  Mousetrap.bind 'down', ->
    Cork.Helpers.slide('down')

  $(document).on 'click', 'header a[href^=/]', (e)->
    e.preventDefault()
    Router.navigate $(this).attr('href'), true

  Cork.checkUrlInterval = setInterval(Cork.Helpers.checkUrl, 50)
  hash = window.location.hash if window.location.hash
  Backbone.history.start pushState: true
  if hash and not window.location.hash
    Router.navigate('/')
    window.location.hash = hash
