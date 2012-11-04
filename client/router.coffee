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
      @showUsersBoard(Meteor.user().profile.slug)
    else
      # figure out what to do until the user is loaded
      @navigate('/', true)

  showUsersBoard: (slug)->
    @showBoard("user-#{slug.replace(/\/$/, '')}")

  showBoard: (boardSlug)->
    Session.set('boardSlug', boardSlug)
    Cork.centerInterval = setInterval(->
      return unless $('#center').length > 0
      setTimeout(->
        Cork.Helpers.centerBoard()
      , 200)
      clearInterval Cork.centerInterval
    , 200)
