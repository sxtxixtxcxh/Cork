Cork.Helpers.selectorCache = (name, selector, force)->
  return window["_#{name}"] if window["_#{name}"] and window["_#{name}"].length > 0 and !force
  window["_#{name}"] = $(selector)
