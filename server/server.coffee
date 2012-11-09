Meteor.publish "users", ()->
  return Meteor.users.find({})

Meteor.publish "posts", (boardId)->
  Posts.find({board: boardId}, sort:{createdAt: 1})

Meteor.publish "boards", (userId)->
  Boards.find({users: userId})
  Boards.find({})

Accounts.onCreateUser (options, user)->
  user.admin = true if options.email is 'sxtxixtxcxh@gmail.com'
  if (options.profile)
    user.profile = options.profile
  return user

Meteor.users.allow
  update: (userId, docs, fields, modifier)->
    return false if userId is not docs[0]._id or !Meteor.users.findOne(userId).admin
    if modifier['$set']['username']
      return Cork.Models.User.validateUsername modifier['$set']['username']

Meteor.methods
  createUserBoard: (user)->
    Cork.Models.Board.createUserBoard(user)
