Template.home.rendered = ->
  return if this.moveBound
  startPositions = undefined

  Mousetrap.bind 'a', ->
    if Meteor.userLoaded()
      Session.set('showNewPostOverlay', true)

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

Template.settings.rendered = ->
  if Session.get('showSettingsOverlay')
    $('#settings-overlay').css
      opacity: 1

Template.settings.events
  'submit #settings': (e)->
    e.preventDefault()
