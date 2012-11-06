Template.board.rendered = ->
  return if this.moveBound
  startPositions = undefined

  Mousetrap.bind 'a', ->
    if Meteor.userLoaded()
      Session.set('showNewPost', true)

  Mousetrap.bind '1', ->
    return Cork.Helpers.pan {x:'50%', y:'50%'}, {x:0, y:0}, true

  $document = $(document)

  $document.on
    'movestart': (e)->
      return if e.finger > 1
      window.location.hash = ''
      startPositions = Cork.Helpers.bodyBgAndCenterStart()

    'move': (e)->
      return if e.finger > 1
      Cork.Helpers.pan
        x: startPositions.center.x + e.distX,
        y: startPositions.center.y + e.distY
      ,
        x: startPositions.bg.x+e.distX,
        y: startPositions.bg.y+e.distY

    'mousewheel wheel': (e)->
      e.preventDefault()
      e = e.originalEvent || e
      window.location.hash = ''
      startPositions = Cork.Helpers.bodyBgAndCenterStart()
      x = e.wheelDeltaX || - e.deltaX || 0
      y = e.wheelDeltaY || - e.deltaY || 0
      speed = 0.4
      Cork.Helpers.pan
        x: Math.floor(startPositions.center.x + x*speed)
        y: Math.floor(startPositions.center.y + y*speed)
      ,
        x: Math.floor(startPositions.bg.x + x*speed)
        y: Math.floor(startPositions.bg.y + y*speed)

  , '#viewport'

  this.moveBound = true

Template.settings.helpers
  username: ->
    Meteor.user()?.username
  showSettingsOverlay: ->
    Session.get('showSettings')

Template.settings.rendered = ->
  if Session.get('showSettings')
    $('#settings-overlay').css
      opacity: 1

Template.settings.events
  'submit #settings': (e)->
    e.preventDefault()
    $username = $('#username')
    username = $username.val()
    if Meteor.user().username isnt username
      Meteor.users.update Meteor.userId(),
        $set:
          username: username
        ,
        (error)->
          Meteor.call('createUserBoard', Meteor.user()) unless error

Template.viewport.rendered = ->
  Cork.Helpers.selectorCache('$viewport', '#viewport', true)

Template.center.rendered = ->
  Cork.Helpers.selectorCache('$center', '#center', true)
