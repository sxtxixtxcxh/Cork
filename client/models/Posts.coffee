Cork.Models.Posts =
  create: (attributes)->
    attributes = @setAttributes(attributes)
    Posts.insert attributes

  delete: (id)->
    Posts.remove id

  setAttributes: (attributes)->
    body = attributes.body
    attributes.type = Cork.Helpers.detectType(body)
    if body.match(/^http/)
      if attributes.type is 'youtube'
        $link = $('<a>').attr('href', body)
        url = $link[0]
        params = url.search.split('&')
        queryObject = {}
        _.each params, (item, index)->
          keyValuePair = item.split('=')
          queryObject[keyValuePair[0].replace(/^\?/, '')] = keyValuePair[1]
        attributes.type = 'youtube'
        attributes.videoId = queryObject.v

    attributes
