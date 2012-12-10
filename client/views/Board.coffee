Template.settings.helpers
  username: ->
    Meteor.user()?.username
  showSettingsOverlay: ->
    Session.get('showSettings')

Template.settings.rendered = ->
  if Session.get('showSettings')
    $('#settings-overlay').css
      opacity: 1

Template.settings.events
  'click .delete-link': ->
    $('#settings-overlay').css
      opacity: 0
    setTimeout( ->
      Session.set('showSettings', false)
    , 300)
  'keyup input': (e)->
    return Session.set('showSettings', false) if e.keyCode is 27

  'submit #settings': (e)->
    e.preventDefault()
    $username = $('#username')
    username = $username.val()
    if Meteor.user().username isnt username
      Meteor.users.update Meteor.userId(),
        $set:
          username: username
        ,
        (error)->
          Meteor.call('createUserBoard', Meteor.user()) unless error

Template.viewport.rendered = ->
  Cork.Helpers.selectorCache('$viewport', '#viewport', true)

Template.center.rendered = ->
  Cork.Helpers.selectorCache('$center', '#center', true)
