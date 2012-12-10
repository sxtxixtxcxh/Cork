Cork.Helpers.bodyBgAndCenterStart = ()->
  bgPos = $body().css('backgroundPosition').split(' ')
  bgX = parseInt bgPos[0], 10
  bgY = parseInt bgPos[1], 10
  centerPosition = $center().position()
  centerStartX = centerPosition.left
  centerStartY = centerPosition.top

  return {
    center:
      x: centerStartX
      y: centerStartY
    bg:
      x: bgX
      y: bgY
  }
