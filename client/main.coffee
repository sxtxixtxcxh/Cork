Meteor.autosubscribe ->
  Meteor.subscribe "posts", Boards.findOne({slug: Session.get('boardSlug')})?._id
  Meteor.subscribe "boards", (Meteor.userId() if Meteor.user())
  Meteor.subscribe 'users'

Router = new MainRouter()

Meteor.startup ->
  if Modernizr.hasEvent('mousewheel')
    $('html').addClass('mousewheel')
  window.$body = ->
    Cork.Helpers.selectorCache('$body', 'body')
  window.$center = ->
    Cork.Helpers.selectorCache('$center', '#center')
  window.$viewport = ->
    Cork.Helpers.selectorCache('$viewport', '#viewport')

  Mousetrap.bind ['shift+left', 'command+left', 'ctrl+left'], ->
    Cork.Helpers.slide('left', 3)
  Mousetrap.bind ['shift+right', 'command+right', 'ctrl+right'], ->
    Cork.Helpers.slide('right', 3)
  Mousetrap.bind ['shift+up', 'command+up', 'ctrl+up'], ->
    Cork.Helpers.slide('up', 3)
  Mousetrap.bind ['shift+down', 'command+down', 'ctrl+down'], ->
    Cork.Helpers.slide('down', 3)

  Mousetrap.bind ['left', 'h'], ->
    Cork.Helpers.slide('left')
  Mousetrap.bind ['right', 'l'], ->
    Cork.Helpers.slide('right')
  Mousetrap.bind ['up', 'k'], ->
    Cork.Helpers.slide('up')
  Mousetrap.bind ['down', 'j'], ->
    Cork.Helpers.slide('down')

  Mousetrap.bind 'a', ->
    if Meteor.userLoaded()
      Session.set('showNewPost', true)

  Mousetrap.bind 'esc', (e)->
    if Session.equals("showNewPost", true) then Session.set('showNewPost', false)

  Mousetrap.bind '1', ->
    return Cork.Helpers.setBoardPosition {x:'50%', y:'50%'}, {x:0, y:0}, true

  $document = $(document)
  startPositions = {}
  $document.on
    'movestart': (e)->
      return if e.finger > 1
      window.location.hash = ''
      startPositions = Cork.Helpers.bodyBgAndCenterStart()

    'move': (e)->
      return if e.finger > 1
      Cork.Helpers.moveBy
        x: e.distX,
        y: e.distY
        startPositions: startPositions

    'mousewheel wheel': (e)->
      e.preventDefault()
      e = e.originalEvent || e
      window.location.hash = ''
      x = e.wheelDeltaX || - e.deltaX || 0
      y = e.wheelDeltaY || - e.deltaY || 0
      speed = 0.4
      Cork.Helpers.moveBy
        x: x*speed
        y: y*speed

  , '#viewport'

  $document.on 'click', 'header a[href^=/]', (e)->
    e.preventDefault()
    window.location.hash = ''
    Router.navigate $(this).attr('href'), true

  Cork.checkUrlInterval = setInterval(Cork.Helpers.checkUrl, 200)
  hash = window.location.hash if window.location.hash

  Backbone.history.start pushState: true

  # reset that hash, stupid backbone.
  if hash and not window.location.hash
    Router.navigate('/')
    window.location.hash = hash
