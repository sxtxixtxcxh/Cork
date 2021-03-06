Template.posts.helpers
  posts: ->
    Posts.find()
  loggedIn: ->
    Meteor.user

Template.post_detail.rendered =->
  $post = $(this.find('.post'))
  Cork.Helpers.centerBoard() if window.location.hash is "#post:#{this.data._id}"
  Cork.Helpers.addExternalFavicon($post.find('.post-body'))
  id = this.data._id
  $post.css('opacity', 1) unless Meteor.user()

  return unless Meteor.user()
  $post.css('opacity', 1)
  return if this.moveBound
  posX = this.data.position.x
  posY = this.data.position.y
  $post.on
    'movestart': (e)->
      e.stopPropagation()
      $post.addClass('dragging')
      posX = $post.position().left
      posY = $post.position().top
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
          updatedAt: Cork.Models.Post.timestamp()
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
    Cork.Models.Post.delete(this._id)
  'mousedown .post-youtube': (e)->
    e.stopPropagation() unless Modernizr.touch
  'mousedown .selected .post-body': (e)->
    e.stopPropagation() unless Modernizr.touch
  'mouseleave .selected': (e)->
    $(e.target).removeClass('selected')
  'mouseenter .post-body': (e)->
    $postBody = $(e.target)
    return unless e.target.scrollHeight > $postBody.height()
    Cork.scrollPostBodyTimeout = setTimeout(->
      $postBody.on 'mousewheel wheel', (e)->
        e.stopPropagation()
    , 300)
  'mouseleave .post-body': (e)->
    clearTimeout Cork.scrollPostBodyTimeout
    $(e.target).off 'mousewheel'

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
