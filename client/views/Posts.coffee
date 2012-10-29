Meteor.subscribe 'posts'

Cork.posts = Posts.find()

Template.posts.helpers
  posts: ->
    Cork.posts
  isObserver: ->
    Session.get('isObserver')


Template.post_detail.rendered =->
  $post = $(this.find('.post'))
  $post._id = this.data._id
  $postStartX = $post.position().left
  $postStartY = $post.position().top
  Cork.Helpers.addExternalFavicon($post)
  $post.on 'movestart', (e)->
    e.stopPropagation()
    $post.addClass 'dragging'
    $post.css
      position: 'absolute'
      margin: 0
      left: $postStartX
      top: $postStartY

  $post.on 'moveend', (e)->
    e.stopPropagation()
    $postStartX = $post.position().left
    $postStartY = $post.position().top
    Posts.update $post._id,
      $set:
        position:
          x: $postStartX
          y: $postStartY
          z: 10

  $post.on 'move', (e)->
    e.stopPropagation()
    $post.css
      left: $postStartX + e.distX
      top: $postStartY + e.distY

Template.post_detail.destroyed =->
  jQuery('.modal-header').off 'movestart'
  jQuery('.modal-header').off 'movesend'
  jQuery('.modal-header').off 'move'

Template.post_detail.events
  'click .delete-link': (e)->
    e.preventDefault()
    Cork.Models.Posts.delete(this._id)
  'mousedown .post-youtube': (e)->
    e.stopPropagation() unless Modernizr.touch
  'mousedown .post-body': (e)->
    e.stopPropagation() unless Modernizr.touch

Template.post_detail.helpers
  isObserver: ->
    Session.get('isObserver')
  isImage: ->
    if this.type?
      this.type is 'image'
  isYoutube: ->
    if this.type?
      this.type is 'youtube'
  isOwner: ->
    this.userId is Meteor.userId()
  author: ->
    if this.userId
      user = Meteor.users.findOne this.userId
      user?.emails[0].address
  avatar: ->
    if this.userId
      user = Meteor.users.findOne this.userId
      Gravatar.imageUrl(user.emails[0].address) if user
  left: ->
    this.position?.x
  top: ->
    this.position?.y
