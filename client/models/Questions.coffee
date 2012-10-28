Cork.Models.Questions =
  create: (attributes)->
    body = attributes.question
    if body.match(/^http/)
      $link = $('<a>').attr('href', body)
      if $link[0].pathname.toLowerCase().match(/.jpg$|.jpeg$|.png$|.gif$/)
        attributes.type = 'image'
    Questions.insert attributes
  delete: (id)->
    Questions.remove id
