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
    console.log e.currentTarget
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
