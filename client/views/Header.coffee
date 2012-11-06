Template.header.helpers
  loggedIn: ->
    Meteor.user
  personalBoard: ->
    personalBoard = Boards.findOne slug: "user-#{Meteor.userId()}"
    Meteor.user()?.username if personalBoard
  anyBoards: ->
    Boards.find(users: Meteor.userId()).count() > 0
  boards: ->
    Boards.find({type: { $ne: 'user' }, users: Meteor.userId()})
  boardSelectedClass: ->
    '-empty' unless Session.equals("boardSlug", this.slug)

Template.header.events
  'click .add-post': (e)->
    e.preventDefault()
    showNewPost = !Session.get('showNewPost')
    Session.set('showNewPost', showNewPost)

  'click #settings-link': (e)->
    e.preventDefault()
    showSettings = !Session.get('showSettings')
    Session.set('showSettings', showSettings)
