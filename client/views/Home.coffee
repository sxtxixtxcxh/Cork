Template.home.helpers
  isObserver: ->
    Session.get('isObserver')
  loggedIn: ->
    Meteor.user

Template.home.events
  'click #create-new-post': (e)->
    e.preventDefault()
    $newPost = $('#new-post')
    Cork.Models.Posts.create
      body: $newPost.val()
      userId: Meteor.userId()
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

  $viewport.on 'move', (e)->
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
