Cork.Helpers.bodyBgAndCenterStart = ($body, $center)->
  bgPos = $body.css('backgroundPosition').split(' ')
  bgX = parseInt bgPos[0], 10
  bgY = parseInt bgPos[1], 10
  centerStartX = $center.position().left
  centerStartY = $center.position().top
  return {
    center:
      x: centerStartX
      y: centerStartY
    bg:
      x: bgX
      y: bgY
  }
