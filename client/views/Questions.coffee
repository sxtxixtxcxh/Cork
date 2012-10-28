Meteor.subscribe 'questions'

Cork.questions = Questions.find()

Cork.questions.observe
  added: (doc)->
    return unless Session.get('isObserver')
    Session.set('selectedQuestion', doc._id)
    Cork.showQuestionDetail()
  changed: (doc)->
    return if Session.get('isObserver')
    Session.set('selectedQuestion', doc._id)
    Cork.showQuestionDetail()

Template.questions.helpers
  questions: ->
    Cork.questions
  isObserver: ->
    Session.get('isObserver')

Template.question.events
  'click a': (e)->
    e.preventDefault()
    Session.set('selectedQuestion', e.currentTarget.id)
    Cork.showQuestionDetail()

Cork.showQuestionDetail = ->
  Session.set('question', Questions.findOne Session.get("selectedQuestion"))
  Session.set('showQuestionDetail', true)

Template.question_detail.preserve ['#new-answer']

Template.question_detail.rendered =->
  $modal = $(this.find('.modal'))
  $modalStartX = $modal.offset().left
  $modalStartY = $modal.offset().top
  jQuery('.modal-header').on 'movestart', (e)->
    $modal.css
      position: 'absolute'
      margin: 0
      left: $modalStartX
      top: $modalStartY

  jQuery('.modal-header').on 'moveend', (e)->
    $modalStartX = $modal.offset().left
    $modalStartY = $modal.offset().top
    Questions.update Session.get('selectedQuestion'),
      $set:
        position:
          x: $modalStartX
          y: $modalStartY
          z: 10
    Cork.showQuestionDetail()

  jQuery('.modal-header').on 'move', (e)->
    Questions.update Session.get('selectedQuestion'),
      $set:
        position:
          x: $modalStartX + e.distX
          y: $modalStartY + e.distY
          z: 10
    # $modal.css
    #   left: $modalStartX + e.distX
    #   top: $modalStartY + e.distY

Template.question_detail.destroyed =->
  jQuery('.modal-header').off 'movestart'
  jQuery('.modal-header').off 'movesend'
  jQuery('.modal-header').off 'move'

Template.question_detail.events
  'click .cancel': (e)->
    e.preventDefault()
    Session.set('showQuestionDetail', false)
  'click #create-new-answer': (e)->
    e.preventDefault()
    $newAnswer = $('#new-answer')
    Questions.update( Session.get('selectedQuestion'),
      $push:
        answers:
          answer: $newAnswer.val()
    )
    Cork.showQuestionDetail()

Template.question_detail.helpers
  isObserver: ->
    Session.get('isObserver')
  question: ->
    Session.get('question')
  left: ->
    Session.get('question').position?.x
  top: ->
    Session.get('question').position?.y

Template.answer.helpers
  author: ->
    return this.author or 'anonymous'
