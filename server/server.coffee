Meteor.publish 'posts', ->
  collection = Posts.find()
  handle = collection.observe
    updated: (doc)->
      console.log doc
      self.flush()
  collection

Accounts.onCreateUser (options, user)->
  user.admin = true if options.email is 'sxtxixtxcxh@gmail.com'
  if (options.profile)
    user.profile = options.profile
  return user

Meteor.publish 'users', ->
  Meteor.users.find()
