Cork.Helpers.slide = (direction, speed)->
  $body = $('body')
  return if $body.hasClass('transition')
  $center = $('#center')
  speed ||= 1
  dist = 240 * speed
  $body.addClass('transition')
  $center.addClass('transition')
  setTimeout(->
    $body.removeClass('transition')
    $center.removeClass('transition')
  , 300)
  position = Cork.Helpers.bodyBgAndCenterStart($body, $center)

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
    $el: $center
    x: position.center.x
    y: position.center.y
  ,
    $el: $body
    x: position.bg.x
    y: position.bg.y

Cork.Helpers.pan = (center, bg)->
    center.$el.css
      left: center.x
      top: center.y
    bg.$el.css 'backgroundPosition', "#{bg.x}px #{bg.y}px"

Cork.Helpers.zoom = (x)->
    Session.set('scale', x)
    $center = $('#center')
    $center.transition {
      scale: "#{x}"
    }, 300, 'in'

