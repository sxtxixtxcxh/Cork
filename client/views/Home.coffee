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
    $body = $('body')
    $bgPos = $body.css('backgroundPosition').split(' ')
    $bgX = parseInt $bgPos[0], 10
    $bgY = parseInt $bgPos[1], 10
    x = - $bgX - 120
    y = - $bgY
    Cork.Models.Posts.create
      body: $newPost.val()
      userId: Meteor.userId()
      position:
        x: x
        y: y
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
  $center = $('#center')
  $body = $('body')
  startPositions = undefined

  Mousetrap.bind 'a', ->
    if Meteor.userLoaded()
      Session.set('showNewPostOverlay', true)

  $document = $(document)
  $document.on
    'mousewheel DOMMouseScroll': _.debounce( (e)->
      delta = e.originalEvent.wheelDelta || - e.originalEvent.detail
      scale = parseFloat($('#center').css('transform')?.scale?.split(',')?[0]) || 1
      if delta > 0 and scale is 0.25
        zoomScale = 1
      if scale is 1 and delta < 0
        zoomScale = 0.25
      if zoomScale
        Cork.Helpers.zoom(zoomScale)
    , 300, true)
  , '#viewport'

  # $document.on
  #   'mousewheel DOMMouseScroll': (e, arg2)->
  #     e.preventDefault()
  #     delta = e.wheelDelta || -e.detail

  #     $center = $('#center')
  #     $body = $('body')
  #     startPositions = Cork.Helpers.bodyBgAndCenterStart $body, $center
  #     x = e.originalEvent.wheelDeltaX
  #     y = e.originalEvent.wheelDeltaY
  #     speed = 0.4
  #     Cork.Helpers.pan
  #       $el: $center
  #       x: startPositions.center.x + x*speed
  #       y: startPositions.center.y + y*speed
  #     ,
  #       $el: $body
  #       x: startPositions.bg.x + x*speed
  #       y: startPositions.bg.y + y*speed
  # , '#viewport'

  $document.on
    'movestart': (e)->
      return if e.finger > 1
      $center = $('#center')
      $body = $('body')
      startPositions = Cork.Helpers.bodyBgAndCenterStart $body, $center
    'move': (e)->
      return if e.finger > 1
      Cork.Helpers.pan
        $el: $center,
        x: startPositions.center.x + e.distX,
        y: startPositions.center.y + e.distY
      ,
        $el: $body,
        x: startPositions.bg.x+e.distX,
        y: startPositions.bg.y+e.distY
  , '#viewport'

  this.moveBound = true
