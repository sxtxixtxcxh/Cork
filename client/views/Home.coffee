Template.home.helpers
  showQuestionDetail: ->
    return Session.get("showQuestionDetail")
  isObserver: ->
    Session.get('isObserver')
  loggedIn: ->
    Meteor.user

Template.home.events
  'click #create-new-question': (e)->
    e.preventDefault()
    $newQuestion = $('#new-question')
    Questions.insert
      question: $newQuestion.val()
      userId: Meteor.userId()
    $newQuestion.val('')
