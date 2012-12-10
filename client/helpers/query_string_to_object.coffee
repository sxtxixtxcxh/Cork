Cork.Helpers.queryStringToObject = (queryString)->
  params = queryString.split('&')
  queryObject = {}
  _.each params, (item, index)->
    keyValuePair = item.split('=')
    queryObject[keyValuePair[0].replace(/^\?/, '')] = keyValuePair[1]
  queryObject
