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
  'click #create-new-post': (e)->
    e.preventDefault()
    $newPost = $('#new-post')
    return unless $newPost.val()
    $body = $('body')
    Cork.Models.Posts.create
      body: $newPost.val()
      userId: Meteor.userId()
      position:
        x: parseInt($body.css('backgroundPositionX')) * -1
        y: parseInt($body.css('backgroundPositionY')) * -1
        z: 10
    $newPost.val('')
    $('.new-post').attr('class', 'new-post post')
  'mousedown textarea': (e)->
    e.stopPropagation()
  'keyup textarea': (e)->
    $newPost = $('.new-post')
    $newPost.attr('class', 'new-post post')
    type = Cork.Helpers.detectType($(e.currentTarget).val())
    $newPost.addClass type

Template.home.rendered = ->
  $newPost = $(this.find('.new-post'))
  if $newPost.length > 0
    $newPostStartX = $newPost.offset().left
    $newPostStartY = $newPost.offset().top
    $newPost.on 'movestart', (e)->
      $newPost.css
        bottom: 'auto'
        top: $newPostStartY
    $newPost.on 'moveend', (e)->
      $newPostStartX = $newPost.offset().left
      $newPostStartY = $newPost.offset().top
    $newPost.on 'move', (e)->
      $newPost.css
        left: $newPostStartX + e.distX
        top: $newPostStartY + e.distY

  $center = $('#center')
  $body = $('body')
  $bgX = 0
  $bgY = 0
  $centerStartX = $center.position().left
  $centerStartY = $center.position().top

  $viewport = $('#viewport')
  $viewport.on 'movestart', (e)->
    return if e.finger > 1
  $viewport.on 'move', (e)->
    return if e.finger > 1
    $center.css
      left: $centerStartX + e.distX
      top: $centerStartY + e.distY
    $body.css
      backgroundPositionX: $bgX + e.distX
      backgroundPositionY: $bgY + e.distY

  $viewport.on 'moveend', (e)->
    $centerStartX = $center.position().left
    $centerStartY = $center.position().top
    $bgX = parseInt $body.css('backgroundPositionX')
    $bgY = parseInt $body.css('backgroundPositionY')
