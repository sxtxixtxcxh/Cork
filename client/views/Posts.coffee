Meteor.autosubscribe ->
  Meteor.subscribe "posts", Session.get('boardSlug')
  Meteor.subscribe "boards", Meteor.userId() if Meteor.user()

Cork.posts = Posts.find()
Cork.boards = Boards.find()

Template.posts.helpers
  posts: ->
    Cork.posts
  isObserver: ->
    Session.get('isObserver')

Template.post_detail.rendered =->
  $post = $(this.find('.post'))
  $post.css('opacity', 1)
  Cork.Helpers.addExternalFavicon($post)
  id = this.data._id

  return unless Meteor.user()
  return if this.moveBound
  posX = this.data.position.x
  posY = this.data.position.y

  $post.on
    'movestart': (e)->
      e.stopPropagation()
      $post.addClass('dragging')

    'moveend': (e)->
      e.stopPropagation()
      $post.removeClass('dragging')
      posX = $post.position().left
      posY = $post.position().top
      Posts.update id,
        $set:
          position:
            x: posX
            y: posY
            z: 10
    'move': (e)->
      e.stopPropagation()
      $post.css
        left: posX + e.distX
        top: posY + e.distY
  this.moveBound = true

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
  canDelete: ->
    return Meteor.user()
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
