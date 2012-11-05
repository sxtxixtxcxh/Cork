Template.home.helpers
  isObserver: ->
    Session.get('isObserver')
  loggedIn: ->
    Meteor.user
  personalBoard: ->
    Meteor.user().profile?.slug if Meteor.userLoaded()
  anyBoards: ->
    (Cork.boards || Meteor.user()?.profile.slug)
  boards: ->
    Cork.boards
  boardSelectedClass: ->
    '-empty' unless Session.equals("boardSlug", this.slug)

Template.home.events
  'click .add-post': (e)->
    e.preventDefault()
    $target = $(e.target)
    Session.set('showNewPostOverlay', true)

Template.new_post.helpers
  showNewPostOverlay: ->
    Session.get('showNewPostOverlay')

Template.new_post.events
  'click .delete-link': ->
    $('#new-post-overlay').css
      opacity: 0
    setTimeout( ->
      Session.set('showNewPostOverlay', false)
    , 300)

  'click #create-new-post': (e)->
    e.preventDefault()
    $newPost = $('#new-post')
    return unless $newPost.val()
    $bgPos = $body().css('backgroundPosition').split(' ')
    $bgX = parseInt $bgPos[0], 10
    $bgY = parseInt $bgPos[1], 10
    scale = 1/(Session.get('scale') or 1)
    x = - $bgX - (120/scale)
    y = - $bgY
    Cork.Models.Posts.create
      body: $newPost.val()
      userId: Meteor.userId()
      position:
        x: x*scale
        y: y*scale
        z: 10
    $('#new-post-overlay').css
      opacity: 0
    setTimeout( ->
      Session.set('showNewPostOverlay', false)
    , 300)

  'mousedown .new-post': (e)->
    e.stopPropagation()

  'mousedown textarea': (e)->
    e.stopPropagation()

  'keyup textarea': (e)->
    $newPost = $('.new-post')
    $newPost.attr('class', 'new-post post')
    type = Cork.Helpers.detectMedia($(e.currentTarget).val()).type
    $newPost.addClass type
    Session.set('showNewPostOverlay', false) if e.keyCode is 27

Template.new_post.rendered = ->
  if Session.get('showNewPostOverlay')
    $('#new-post-overlay').css
      opacity: 1

  $newPost = $(this.find('#new-post'))
  $newPost.focus()

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

    # 'mousewheel DOMMouseScroll': _.debounce( (e)->
    #   delta = e.originalEvent.wheelDelta || - e.originalEvent.detail
    #   scale = parseFloat($('#center').css('transform')?.scale?.split(',')?[0]) || 1
    #   if delta > 0 and scale is 0.5
    #     zoomScale = 1
    #   if scale is 1 and delta < 0
    #     zoomScale = 0.5
    #   if zoomScale
    #     Cork.Helpers.zoom(zoomScale)
    # , 300, true)
    #
    # Firefox < 17 wheel event
    # 'wheel': (e)->
    #   e.preventDefault()
    #   e = e.originalEvent
    #   startPositions = Cork.Helpers.bodyBgAndCenterStart()
    #   console.log e
    #   x = y = 0
    #   switch e.axis
    #     when 1
    #       x = - e.detail
    #     when 2
    #       y = - e.detail
    #   speed = 1
    #   Cork.Helpers.pan
    #     x: startPositions.center.x + x*speed
    #     y: startPositions.center.y + y*speed
    #   ,
    #     x: startPositions.bg.x + x*speed
    #     y: startPositions.bg.y + y*speed


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
