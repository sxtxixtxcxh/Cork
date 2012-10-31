Template.home.helpers
  isObserver: ->
    Session.get('isObserver')
  loggedIn: ->
    Meteor.user
  anyBoards: ->
    Cork.boards
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
    x = - (parseInt($body.css('backgroundPositionX'), 10)) - 120
    y = - (parseInt($body.css('backgroundPositionY'), 10))
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
  $center = $('#center')
  $body = $('body')
  $bgX = 0
  $bgY = 0
  $centerStartX = $center.position().left
  $centerStartY = $center.position().top

  Mousetrap.bind 'a', ->
    Session.set('showNewPostOverlay', true)

  $viewport = $('#viewport')
  $viewport.on 'movestart', (e)->
    return if e.finger > 1
    $centerStartX = $center.position().left
    $centerStartY = $center.position().top
    $bgX = parseInt $body.css('backgroundPositionX'), 10
    $bgY = parseInt $body.css('backgroundPositionY'), 10
  $viewport.on 'move', (e)->
    return if e.finger > 1
    $center.css
      left: $centerStartX + e.distX
      top: $centerStartY + e.distY
    $body.css
      backgroundPositionX: $bgX + e.distX
      backgroundPositionY: $bgY + e.distY
