Cork.Models.Posts =
  create: (attributes)->
    attributes = @processAttributes(attributes)
    attributes.boardSlug = Session.get('boardSlug')
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
      media = Cork.Helpers.detectMedia(body)
      attributes.type = media.type
      attributes.mediaUrl = media.mediaUrl
      if attributes.type is 'youtube'
        url = attributes.mediaUrl
        attributes.videoId = Cork.Helpers.queryStringToObject(url.search).v

    attributes
