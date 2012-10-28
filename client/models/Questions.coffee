Cork.Models.Questions =
  create: (attributes)->
    body = attributes.question
    if body.match(/^http/) and body.toLowerCase().match(/.jpg$|.jpeg$|.png$|.gif$/)
      attributes.type = 'image'
    Questions.insert attributes
  delete: (id)->
    Questions.remove id
