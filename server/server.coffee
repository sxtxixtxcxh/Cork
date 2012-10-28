Meteor.publish 'questions', ->
  collection = Questions.find()
  handle = collection.observe
    updated: (doc)->
      console.log doc
      self.flush()
  collection

Meteor.publish 'users', ->
  Meteor.users.find()

