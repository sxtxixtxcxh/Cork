Router = new MainRouter()

Meteor.startup ->
  window.$body = $('body')
  window.$center = $('#center')

  Mousetrap.bind ['shift+left', 'command+left', 'ctrl+left', 'h'], ->
    Cork.Helpers.slide('left', 3)
  Mousetrap.bind ['shift+right', 'command+right', 'ctrl+right', ], ->
    Cork.Helpers.slide('right', 3)
  Mousetrap.bind ['shift+up', 'command+up', 'ctrl+up'], ->
    Cork.Helpers.slide('up', 3)
  Mousetrap.bind ['shift+down', 'command+down', 'ctrl+down'], ->
    Cork.Helpers.slide('down', 3)

  Mousetrap.bind ['left', 'h'], ->
    Cork.Helpers.slide('left')
  Mousetrap.bind ['right', 'l'], ->
    Cork.Helpers.slide('right')
  Mousetrap.bind ['up', 'k'], ->
    Cork.Helpers.slide('up')
  Mousetrap.bind ['down', 'j'], ->
    Cork.Helpers.slide('down')

  $(document).on 'click', 'header a[href^=/]', (e)->
    e.preventDefault()
    Router.navigate $(this).attr('href'), true

  Cork.checkUrlInterval = setInterval(Cork.Helpers.checkUrl, 50)
  hash = window.location.hash if window.location.hash

  Backbone.history.start pushState: true

  # reset that hash, stupid backbone.
  if hash and not window.location.hash
    Router.navigate('/')
    window.location.hash = hash
