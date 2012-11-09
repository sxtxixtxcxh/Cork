Cork.Models.User =
  validateUsername: (username)->
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
