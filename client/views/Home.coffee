Template.home.helpers
  showQuestionDetail: ->
    return Session.get("showQuestionDetail")
  isObserver :->
    Session.get('isObserver')

Template.home.events
  'click #create-new-question': (e)->
    e.preventDefault()
    $newQuestion = $('#new-question')
    Questions.insert
      question: $newQuestion.val()
    $newQuestion.val('')
