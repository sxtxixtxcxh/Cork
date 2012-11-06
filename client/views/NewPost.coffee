Template.new_post.helpers
  showNewPostOverlay: ->
    Session.get('showNewPost')

Template.new_post.events
  'click .delete-link': ->
    $('#new-post-overlay').css
      opacity: 0
    setTimeout( ->
      Session.set('showNewPost', false)
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
      Session.set('showNewPost', false)
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
    Session.set('showNewPost', false) if e.keyCode is 27

Template.new_post.rendered = ->
  if Session.get('showNewPost')
    $('#new-post-overlay').css
      opacity: 1

  $newPost = $(this.find('#new-post'))
  $newPost.focus()
