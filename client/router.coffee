class MainRouter extends Backbone.Router
  routes:
    "": "main"
    "home": "myBoard"
    "users/:slug": "showUsersBoard"
    "boards/:board": "showBoard"

  main: ()->
    @showBoard()

  myBoard: ()->
    if Meteor.user() and Meteor.userLoaded()
      @showUsersBoard(Meteor.user().username)
    else
      # figure out what to do until the user is loaded
      @navigate('/', true)

  showUsersBoard: (slug)->
    slug = slug.replace(/\/$/, '')
    user = Meteor.users.findOne({username: slug})
    @showBoard("user-#{user._id}") if user

  showBoard: (boardSlug)->
    Session.set('boardSlug', boardSlug)
    board = Boards.findOne slug: boardSlug || ''
    Session.set('board', board)
    Cork.centerInterval = setInterval(->
      return unless $center().length > 0
      setTimeout(->
        Cork.Helpers.centerBoard()
      , 200)
      clearInterval Cork.centerInterval
    , 200)
