Cork.Helpers.detectMedia = (content)->
  lines = content.split("\n")
  tokens = _.flatten _.map lines, (item)->
    item.split(' ')
  type = undefined
  _.find tokens, (item, i)->
    url = $('<a>').attr('href', item)[0]
    path = url.pathname.toLowerCase()
    if path.match(/.jpg$|.jpeg$|.png$|.gif$/)
      type = {type: 'image', mediaUrl: url.href}
      return true
    if url.hostname.match(/youtube.com/)
      type = {type: 'youtube', mediaUrl: url.href}
      return true
  type ||= {type: 'post', mediaUrl: undefined}
  return type
