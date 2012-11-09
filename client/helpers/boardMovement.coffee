Cork.Helpers.slide = (direction, speed)->
  return if $body().hasClass('transition')
  speed ||= 1
  dist = 240 * speed
  position = Cork.Helpers.bodyBgAndCenterStart()
  distX = distY = 0
  switch direction
    when 'left'
      distX += dist
    when 'right'
      distX -= dist
    when 'up'
      distY += dist
    when 'down'
      distY -= dist

  Cork.Helpers.moveBy
    x: distX
    y: distY
    slide: true

Cork.Helpers.transitionBoard = ()->
  $body().addClass('transition')
  $center().addClass('transition')
  setTimeout(->
    $body().removeClass('transition')
    $center().removeClass('transition')
  , 300)

Cork.Helpers.moveBy = (options)->
  distX = options.x
  distY = options.y
  startPositions = options.startPositions || Cork.Helpers.bodyBgAndCenterStart()
  slide = options.slide

  centerEndPosition =
    x: Math.floor(startPositions.center.x + distX)
    y: Math.floor(startPositions.center.y + distY)

  bgEndPosition =
    x: Math.floor(startPositions.bg.x + distX)
    y: Math.floor(startPositions.bg.y + distY)

  Cork.Helpers.setBoardPosition( centerEndPosition, bgEndPosition, slide)

Cork.Helpers.setBoardPosition = (center, bg, slide)->
  Cork.Helpers.transitionBoard() if slide
  $center().css
    left: center.x
    top: center.y
  $body().css 'backgroundPosition', "#{bg.x}px #{bg.y}px"
  clearTimeout Cork.setPermalinkTimeout
  Cork.setPermalinkTimeout = setTimeout(Cork.Helpers.setPermalink, 300)
  true

Cork.Helpers.setPermalink = ->
  relativeX = $viewport().width()/2 - $center().position().left
  relativeY = - ($viewport().height()/2 - $center().position().top)
  $('#viewport-permalink').attr 'href', "#x:#{relativeX};y:#{relativeY}"

Cork.Helpers.zoom = (x)->
  Session.set('scale', x)
  $center().transition {
    scale: "#{x}"
  }, 300, 'in'
