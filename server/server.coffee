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

Cork.Models.User ||= {}
Cork.Models.User.validateUsername = (username)->
  if username
    if 3 <= username.length <= 15
      if username.match(/^([a-zA-Z0-9_-])+$/)
        return true
      else
        throw new Meteor.Error(403, "Username can only have letters, numbers and '-', '_' characters")
    else
      throw new Meteor.Error(403, "Username has to be at least 3 and no more than 15 characters")
  else
    throw new Meteor.Error(403, "Username can't be blank")
  return false

Cork.Models.Board ||= {}
Cork.Models.Board.createUserBoard = (user)->
  if Boards.findOne(slug: "user-#{user._id}")
    Meteor.Error(403, "Board already exists.")
  else
    Boards.insert
      users: [user._id]
      type: 'user'
      owner: user._id
      slug: "user-#{user._id}"

Meteor.users.allow
  update: (userId, docs, fields, modifier)->
    return false if userId is not docs[0]._id or !Meteor.users.findOne(userId).admin
    if modifier['$set']['username']
      return Cork.Models.User.validateUsername modifier['$set']['username']

Meteor.methods
  createUserBoard: (user)->
    Cork.Models.Board.createUserBoard(user)
