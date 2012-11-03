Cork.Helpers.centerBoard = ->
  $center = $('#center')
  $body = $('body')
  position = Cork.Helpers.bodyBgAndCenterStart($body, $center)
  coords = Cork.coordHash?.replace(/#/,'')
  if coords?.match(/x:\d+|y:\d+/)
    coords = coords.split(';')
    center = _.map coords, (item)->
      coord = item.split(':')
      position.center[coord[0]] = coord[1]
      position.bg[coord[0]] = coord[1]
    center=
      $el: $center
      x: "#{position.center.x}px"
      y: "#{position.center.y}px"
    bg=
      $el: $body
      x: position.bg.x
      y: position.bg.y
    $body.addClass('transition')
    $center.addClass('transition')
    setTimeout(->
      $body.removeClass('transition')
      $center.removeClass('transition')
    , 300)

    Cork.Helpers.pan center, bg


