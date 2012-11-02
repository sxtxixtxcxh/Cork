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
    # x = if x >= 0 then x - 120 else x + 120
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
    'mousewheel': (e)->
      e.preventDefault()
      $center = $('#center')
      $body = $('body')
      startPositions = Cork.Helpers.bodyBgAndCenterStart $body, $center
      x = e.originalEvent.wheelDeltaX
      y = e.originalEvent.wheelDeltaY
      Cork.Views.Home.pan
        $el: $center
        x: startPositions.center.x + x
        y: startPositions.center.y + y
      ,
        $el: $body
        x: startPositions.bg.x + x
        y: startPositions.bg.y + y
  , '#viewport'
  $document.on
    'movestart': (e)->
      return if e.finger > 1
      $center = $('#center')
      $body = $('body')
      startPositions = Cork.Helpers.bodyBgAndCenterStart $body, $center
    'move': (e)->
      return if e.finger > 1
      Cork.Views.Home.pan
        $el: $center,
        x: startPositions.center.x + e.distX,
        y: startPositions.center.y + e.distY
      ,
        $el: $body,
        x: startPositions.bg.x+e.distX,
        y: startPositions.bg.y+e.distY
  , '#viewport'
  this.moveBound = true



