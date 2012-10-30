Cork.Models.Posts =
  create: (attributes)->
    attributes = @setAttributes(attributes)
    Posts.insert attributes

  delete: (id)->
    Posts.remove id

  update: (id, attributes)->
    attributes = @processAttributes(attributes)
    Posts.update id,
      $set:
        attributes

  setPosition: (attributes)->
    attributes.position   ||= {}
    attributes.position.x ||= 0
    attributes.position.y ||= 0
    attributes.position


  processAttributes: (attributes)->
    attributes.position = @setPosition(attributes)

    body = attributes.body
    if body
      attributes.type = Cork.Helpers.detectType(body)
      if body.match(/^http/)
        if attributes.type is 'youtube'
          $link = $('<a>').att
          r('href', body)
          url = $link[0]
          params = url.search.split('&')
          queryObject = {}
          _.each params, (item, index)->
            keyValuePair = item.split('=')
            queryObject[keyValuePair[0].replace(/^\?/, '')] = keyValuePair[1]
          attributes.type = 'youtube'
          attributes.videoId = queryObject.v

    attributes
