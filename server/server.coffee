Accounts.onCreateUser (options, user)->
  user.admin = true if options.email is 'sxtxixtxcxh@gmail.com'
  if (options.profile)
    user.profile = options.profile
  return user

# Meteor.publish 'users', ->
#   Meteor.users.find()

Meteor.publish "posts", (boardSlug)->
  Posts.find({boardSlug: boardSlug})

Meteor.publish "boards", (userId)->
  Boards.find({users: userId})
