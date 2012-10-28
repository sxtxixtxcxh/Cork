Cork.Models.Questions =
  create: (attributes)->
    attributes = @setType(attributes)
    Questions.insert attributes

  delete: (id)->
    Questions.remove id

  setType: (attributes)->
    body = attributes.question
    if body.match(/^http/)
      $link = $('<a>').attr('href', body)
      url = $link[0]
      path = url.pathname.toLowerCase()

      image = path.match(/.jpg$|.jpeg$|.png$|.gif$/)
      if image
        attributes.type = 'image'

      youtube = url.hostname.match(/.youtube.com/)
      if youtube.length > 0 and body is url.href
        params = url.search.split('&')
        queryObject = {}
        _.each params, (item, index)->
          keyValuePair = item.split('=')
          queryObject[keyValuePair[0].replace(/^\?/, '')] = keyValuePair[1]

        attributes.type = 'youtube'

        attributes.videoId = queryObject.v

    attributes
