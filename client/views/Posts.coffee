Meteor.autosubscribe ->
  Meteor.subscribe "posts", Session.get('boardSlug')
  Meteor.subscribe "boards", Meteor.userId() if Meteor.user()

Cork.posts = Posts.find()
Cork.boards = Boards.find()

Template.posts.helpers
  posts: ->
    Cork.posts
  loggedIn: ->
    Meteor.user

Template.posts.rendered =->
  Cork.Helpers.centerBoard()

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
      scale = 1/(Session.get('scale') or 1)
      Posts.update id,
        $set:
          position:
            x: Math.floor(posX*scale)
            y: Math.floor(posY*scale)
            z: 10
          updatedAt:
            Cork.Models.Posts.timestamp()
    'move': (e)->
      e.stopPropagation()
      scale = 1/(Session.get('scale') or 1)
      $post.css
        left: Math.floor((posX*scale + e.distX*scale))
        top: Math.floor((posY*scale + e.distY*scale))

  this.moveBound = true

Template.post_detail.events
  'click': (e)->
    $(e.target).closest('.post').toggleClass('selected')
  'click .post-permalink': (e)->
    e.preventDefault()
    url = $("<a>").attr('href', e.target.href)[0]
    window.location.hash = url.hash
  'click .delete-link': (e)->
    e.preventDefault()
    Cork.Models.Posts.delete(this._id)
  'mousedown .post-youtube': (e)->
    e.stopPropagation() unless Modernizr.touch
  'mousedown .selected .post-body': (e)->
    e.stopPropagation() unless Modernizr.touch
  'mouseleave .selected': (e)->
    $(e.target).removeClass('selected')

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
  relativeLeft: ->
    parseFloat(this.position?.x + 120)
  relativeTop: ->
    parseFloat(this.position?.y * -1)
