constants = require './constants.coffee'
module.exports = 
  #Creates a pseudo unique Id
  uniqueId: (length=8) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
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
  # Take time in seconds and offset in milliseconds and formats it as a string
  toClock: (time, offset = false) ->
    # hours = Math.floor(time / constants.HOUR_IN_MS)
    hours = 0
    #minutes = Math.floor((time % constants.HOUR_IN_MS) / constants.MINUTE_IN_MS)
    minutes = Math.floor(time / constants.MINUTE_IN_MS)
    seconds = Math.floor((time % constants.MINUTE_IN_MS) / constants.SECOND_IN_MS)
    milliseconds = time % constants.SECOND_IN_MS
    #Only Display signfication Sections
    strTime = ""
    if hours > 0
      strTime = "#{@pad(hours,2)}:"
    if minutes > 0
      strTime = strTime + "#{@pad(minutes,2)}:"
    strTime = strTime + "#{@pad(seconds,2)}"
    if offset == true
      strTime = strTime + ".#{@pad(milliseconds, 3)}"
    return strTime