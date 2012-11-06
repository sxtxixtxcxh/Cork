Meteor.autosubscribe ->
  Meteor.subscribe "posts", Boards.findOne({slug: Session.get('boardSlug')})?._id
  Meteor.subscribe "boards", (Meteor.userId() if Meteor.user())
  Meteor.subscribe 'users'

# Cork.posts = Posts.find()
# Cork.boards = Boards.find()

Router = new MainRouter()

Meteor.startup ->
  if Modernizr.hasEvent('mousewheel')
    $('html').addClass('mousewheel')
  window.$body = ->
    Cork.Helpers.selectorCache('$body', 'body')
  window.$center = ->
    Cork.Helpers.selectorCache('$center', '#center')
  window.$viewport = ->
    Cork.Helpers.selectorCache('$viewport', '#viewport')

  Mousetrap.bind ['shift+left', 'command+left', 'ctrl+left'], ->
    Cork.Helpers.slide('left', 3)
  Mousetrap.bind ['shift+right', 'command+right', 'ctrl+right'], ->
    Cork.Helpers.slide('right', 3)
  Mousetrap.bind ['shift+up', 'command+up', 'ctrl+up'], ->
    Cork.Helpers.slide('up', 3)
  Mousetrap.bind ['shift+down', 'command+down', 'ctrl+down'], ->
    Cork.Helpers.slide('down', 3)

  Mousetrap.bind ['left', 'h'], ->
    Cork.Helpers.slide('left')
  Mousetrap.bind ['right', 'l'], ->
    Cork.Helpers.slide('right')
  Mousetrap.bind ['up', 'k'], ->
    Cork.Helpers.slide('up')
  Mousetrap.bind ['down', 'j'], ->
    Cork.Helpers.slide('down')

  $(document).on 'click', 'header a[href^=/]', (e)->
    e.preventDefault()
    window.location.hash = ''
    Router.navigate $(this).attr('href'), true

  Cork.checkUrlInterval = setInterval(Cork.Helpers.checkUrl, 200)
  hash = window.location.hash if window.location.hash

  Backbone.history.start pushState: true

  # reset that hash, stupid backbone.
  if hash and not window.location.hash
    Router.navigate('/')
    window.location.hash = hash
