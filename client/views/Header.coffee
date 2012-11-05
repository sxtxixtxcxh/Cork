Template.header.helpers
  loggedIn: ->
    Meteor.user
  personalBoard: ->
    Meteor.user().username if Meteor.userLoaded()
  anyBoards: ->
    (Cork.boards || Meteor.user()?.profile?.slug)
  boards: ->
    Boards.find({type: { $ne: 'user'}})
  boardSelectedClass: ->
    '-empty' unless Session.equals("boardSlug", this.slug)

Template.settings.helpers
  showSettingsOverlay: ->
    Session.get('showSettingsOverlay')

Template.header.events
  'click .add-post': (e)->
    e.preventDefault()
    showNewPost = !Session.get('showNewPostOverlay')
    Session.set('showNewPostOverlay', showNewPost)
  'click #settings-link': (e)->
    e.preventDefault()
    showSettings = !Session.get('showSettingsOverlay')
    Session.set('showSettingsOverlay', showSettings)
