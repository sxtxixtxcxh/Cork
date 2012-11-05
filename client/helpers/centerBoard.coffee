Cork.Helpers.centerBoard = ->
  coords = @readCoords(Cork.coordHash)
  if coords
    position = Cork.Helpers.bodyBgAndCenterStart()
    width = $viewport().width()
    height = $viewport().height()
    position.center.x = width/2 - coords.x
    position.center.y = height/2 + coords.y
    position.bg.x =  - coords.x if coords.x
    position.bg.y = coords.y
    center=
      x: position.center.x
      y: position.center.y
    bg=
      x: position.bg.x
      y: position.bg.y
    $body().addClass('transition')
    $center().addClass('transition')
    setTimeout(->
      $body().removeClass('transition')
      $center().removeClass('transition')
    , 300)

    return Cork.Helpers.pan center, bg
  return Cork.Helpers.pan {x:'50%', y:'50%'}, {x:0, y:0}

Cork.Helpers.readCoords = (coordHash)->
  coords = coordHash?.replace(/#/,'')
  if coords?.match(/x:-*\d+|y:-*\d+/)
    coords = coords.split(';')
    viewPort = {}
    _.map coords, (item)->
      coord = item.split(':')
      viewPort[coord[0]] = parseFloat(coord[1])
    coords = viewPort
  else if coords?.match(/^post:.*/)
    id = coords?.replace('post:', '')
    post = Posts.findOne(id)
    return false unless post
    coords =
      x: post.position.x + 120
      y: - post.position.y - $("#post-#{id}").height()/2
  else
    coords = false
  return coords
