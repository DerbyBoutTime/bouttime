constants = require './constants'
module.exports =
  #Creates a pseudo unique Id
  uniqueId: (length=8, rng=Math.random) ->
    id = ""
    id += rng().toString(36).substr(2) while id.length < length
    id.substr 0, length
  #Pads a number
  pad: (num, digits) ->
    if num.toString().length < digits
      ("000" + num).substr(-digits)
    else
      num
  #Gets a URL Parameter non-obtusely
  getParams: ->
    query = window.location.search.substring(1)
    raw_vars = query.split("&")
    params = {}
    for v in raw_vars
      [key, val] = v.split("=")
      params[key] = decodeURIComponent(val)
    params
