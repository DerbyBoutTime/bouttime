exports = exports ? this
#Sets Up the dispatcher
exports.wftda.functions.connectDispatcher = () ->
  exports.dispatcherTimeout = setTimeout( ()->
    console.log('Connection not established... retrying')
    exports.wftda.functions.connectDispatcher()
  ,exports.wftda.constants.WEBSOCKETS_RETRY_TIME_IN_MS)
  exports.dispatcher = new WebSocketRails('localhost:3001/websocket')
  exports.dispatcher.on_open = (data) ->
    console.log('Connection has been established');
    clearTimeout(exports.dispatcherTimeout)
    dispatcher.trigger 'jam_timer.set_game_state_id', wftda.functions.getParams()
#Actually calls the dispatcher setup
exports.wftda.functions.connectDispatcher()
#Creates a pseudo unique Id
exports.wftda.functions.uniqueId = (length=8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length
#Pads a number
exports.wftda.functions.pad = (num, digits) ->
  if num.toString().length < digits
    ("000" + num).substr(-digits)
  else
    num
#Gets a URL Parameter non-obtusely
exports.wftda.functions.getParams = ->
  query = window.location.search.substring(1)
  raw_vars = query.split("&")
  params = {}
  for v in raw_vars
    [key, val] = v.split("=")
    params[key] = decodeURIComponent(val)
  params
# Take time in seconds and offset in milliseconds and formats it as a string
exports.wftda.functions.toClock = (time, offset = false) ->
  # hours = Math.floor(time / exports.wftda.constants.HOUR_IN_MS)
  hours = 0
  #minutes = Math.floor((time % exports.wftda.constants.HOUR_IN_MS) / exports.wftda.constants.MINUTE_IN_MS)
  minutes = Math.floor(time / exports.wftda.constants.MINUTE_IN_MS)
  seconds = Math.floor((time % exports.wftda.constants.MINUTE_IN_MS) / exports.wftda.constants.SECOND_IN_MS)
  milliseconds = time % exports.wftda.constants.SECOND_IN_MS
  #Only Display signfication Sections
  strTime = ""
  if hours > 0
    strTime = "#{exports.wftda.functions.pad(hours,2)}:"
  if minutes > 0
    strTime = strTime + "#{exports.wftda.functions.pad(minutes,2)}:"
  strTime = strTime + "#{exports.wftda.functions.pad(seconds,2)}"
  if offset == true
    strTime = strTime + ".#{exports.wftda.functions.pad(milliseconds, 3)}"
  return strTime