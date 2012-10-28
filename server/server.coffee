Meteor.publish 'posts', ->
  collection = Posts.find()
  handle = collection.observe
    updated: (doc)->
      console.log doc
      self.flush()
  collection

Meteor.publish 'users', ->
  Meteor.users.find()

