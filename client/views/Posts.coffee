Meteor.subscribe 'posts'

Cork.posts = Posts.find()

Template.posts.helpers
  posts: ->
    Cork.posts
  isObserver: ->
    Session.get('isObserver')


Template.post_detail.rendered =->
  $modal = $(this.find('.post'))
  $modal._id = this.data._id
  $modalStartX = $modal.offset().left
  $modalStartY = $modal.offset().top
  Cork.Helpers.addExternalFavicon($modal)
  $modal.on 'movestart', (e)->
    $modal.addClass 'dragging'
    $modal.css
      position: 'absolute'
      margin: 0
      left: $modalStartX
      top: $modalStartY

  $modal.on 'moveend', (e)->
    $modalStartX = $modal.offset().left
    $modalStartY = $modal.offset().top
    Posts.update $modal._id,
      $set:
        position:
          x: $modalStartX
          y: $modalStartY
          z: 10

  $modal.on 'move', (e)->
    $modal.css
      left: $modalStartX + e.distX
      top: $modalStartY + e.distY

Template.post_detail.destroyed =->
  jQuery('.modal-header').off 'movestart'
  jQuery('.modal-header').off 'movesend'
  jQuery('.modal-header').off 'move'

Template.post_detail.events
  'click .delete-link': (e)->
    e.preventDefault()
    Cork.Models.Posts.delete(this._id)
  'mousedown .post-youtube': (e)->
    e.stopPropagation()
  'mousedown .post-body': (e)->
    e.stopPropagation()

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
