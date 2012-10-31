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
  Cork.Helpers.addExternalFavicon($post.find('.post-body'))
  id = this.data._id
  $post.css('opacity', 1) unless Meteor.user()

  return unless Meteor.user() and Meteor.userLoaded()
  $post.css('opacity', 1)

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
  'click': (e)->
    $(e.target).closest('.post').toggleClass('selected')
  'click .delete-link': (e)->
    e.preventDefault()
    Cork.Models.Posts.delete(this._id)
  'mousedown .post-youtube': (e)->
    e.stopPropagation() unless Modernizr.touch
  'mousedown .selected .post-body': (e)->
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
  mediaBody: ->
    return '' unless this.mediaUrl
    escapedUrl = this.mediaUrl.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")
    mediaUrlRegex = new RegExp("^#{escapedUrl}|#{escapedUrl}$","g")
    this.body.replace(mediaUrlRegex, '')
  imageUrl: ->
    this.mediaUrl || this.body
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
