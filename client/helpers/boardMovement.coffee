Cork.Helpers.slide = (direction, speed)->
  return if $body().hasClass('transition')
  speed ||= 1
  dist = 240 * speed
  position = Cork.Helpers.bodyBgAndCenterStart()

  switch direction
    when 'left'
      position.center.x += dist
      position.bg.x += dist
    when 'right'
      position.center.x -= dist
      position.bg.x -= dist
    when 'up'
      position.center.y += dist
      position.bg.y += dist
    when 'down'
      position.center.y -= dist
      position.bg.y -= dist

  Cork.Helpers.pan
    x: position.center.x
    y: position.center.y
  ,
    x: position.bg.x
    y: position.bg.y
  , true


Cork.Helpers.transitionBoard = ()->
  $body().addClass('transition')
  $center().addClass('transition')
  setTimeout(->
    $body().removeClass('transition')
    $center().removeClass('transition')
  , 300)

Cork.Helpers.pan = (center, bg, slide)->
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
