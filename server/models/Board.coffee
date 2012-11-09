Cork.Models.Board =
  createUserBoard: (user)->
    if Boards.findOne(slug: "user-#{user._id}")
      Meteor.Error(403, "Board already exists.")
    else
      Boards.insert
        users: [user._id]
        type: 'user'
        owner: user._id
        slug: "user-#{user._id}"
