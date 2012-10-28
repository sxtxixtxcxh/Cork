Meteor.subscribe 'questions'

Cork.questions = Questions.find()

Template.questions.helpers
  questions: ->
    Cork.questions
  isObserver: ->
    Session.get('isObserver')

Template.question_detail.rendered =->
  $modal = $(this.find('.post'))
  $modal._id = this.data._id
  $modalStartX = $modal.offset().left
  $modalStartY = $modal.offset().top
  Cork.Helpers.addExternalFavicon($modal)
  $modal.on 'movestart', (e)->
    $modal.css
      position: 'absolute'
      margin: 0
      left: $modalStartX
      top: $modalStartY

  $modal.on 'moveend', (e)->
    $modalStartX = $modal.offset().left
    $modalStartY = $modal.offset().top

  $modal.on 'move', (e)->
    Questions.update $modal._id,
      $set:
        position:
          x: $modalStartX + e.distX
          y: $modalStartY + e.distY
          z: 10

Template.question_detail.destroyed =->
  jQuery('.modal-header').off 'movestart'
  jQuery('.modal-header').off 'movesend'
  jQuery('.modal-header').off 'move'

Template.question_detail.events
  'click .cancel': (e)->
    e.preventDefault()
    Session.set('showQuestionDetail', false)

Template.question_detail.helpers
  isObserver: ->
    Session.get('isObserver')
  author: ->
    if this.userId
      user = Meteor.users.findOne this.userId
      user.emails[0].address
  avatar: ->
    if this.userId
      user = Meteor.users.findOne this.userId
      Gravatar.imageUrl(user.emails[0].address) if user
  left: ->
    this.position?.x
  top: ->
    this.position?.y
