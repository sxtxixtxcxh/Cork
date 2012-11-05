Cork.Models.Posts =
  create: (attributes)->
    attributes = @processAttributes(attributes)
    attributes.board = Session.get('board')?._id
    Posts.insert attributes

  delete: (id)->
    Posts.remove id

  update: (id, attributes)->
    attributes = @processAttributes(attributes)
    Posts.update id,
      $set:
        attributes

  timestamp: ()->
    new Date().getTime()

  setPosition: (attributes)->
    attributes.position   ||= {}
    attributes.position.x ||= 0
    attributes.position.y ||= 0
    attributes.position

  processAttributes: (attributes)->
    attributes.position = @setPosition(attributes)
    body = attributes.body
    timestamp = @timestamp()
    attributes.createdAt ||= timestamp
    attributes.updatedAt = timestamp
    if body
      media = Cork.Helpers.detectMedia(body)
      attributes.type = media.type
      attributes.mediaUrl = media.mediaUrl
      if attributes.type is 'youtube'
        url = $('<a>').attr('href', attributes.mediaUrl)[0]
        attributes.videoId = Cork.Helpers.queryStringToObject(url.search).v
    attributes
