Cork.Helpers.checkUrl = ->
  unless window.location.hash is Cork.coordHash
    Cork.coordHash = window.location.hash
    Cork.Helpers.centerBoard() unless Cork.coordHash == ''
