exports = exports ? this
exports.timing = exports.timing ? {}
exports.timing.delays = []
#Sets Up the dispatcher
exports.wftda.functions.connectDispatcher = () ->
  exports.dispatcherTimeout = setTimeout( ()->
    console.log('Connection not established... retrying')
    exports.dispatcher.connect()
  ,exports.wftda.constants.WEBSOCKETS_RETRY_TIME_IN_MS)
  exports.dispatcher = new WebSocketRails("#{window.location.host}/websocket")
  exports.dispatcher.on_open = (data) ->
    console.log('Connection has been established');
    clearTimeout(exports.dispatcherTimeout)
    dispatcher.trigger 'jam_timer.set_game_state_id', wftda.functions.getParams()
    dispatcher.bind 'set_timing_delay', exports.wftda.functions.setTimingDelay
    $(".game").addClass("connected")
    exports.wftda.functions.getTimingDelay()
#Actually calls the dispatcher setup
exports.wftda.functions.connectDispatcher()
#NTP Basics http://stackoverflow.com/questions/1228089/how-does-the-network-time-protocol-work
exports.wftda.functions.getTimingDelay = () ->
  #console.log "Getting timing delay..."
  exports.timing.A = new Date().getTime()
  dispatcher.trigger 'jam_timer.get_timing_delay', {timestamp: exports.timing.A}
exports.wftda.functions.setTimingDelay = (obj) ->
  exports.timing.B = new Date().getTime()
  exports.timing.X = obj.t1
  exports.timing.Y = obj.t2
  exports.timing.delays.push(exports.timing.B - exports.timing.A - (exports.timing.Y - exports.timing.X))
  exports.timing.delay = exports.timing.delays.reduce((b,c)->
    return b+c
  )/exports.timing.delays.length
  exports.timing.trueTime = exports.timing.Y + exports.timing.delay/2
  console.log "Timing Delay: #{exports.timing.delay}ms"
  setTimeout( () ->
    exports.wftda.functions.getTimingDelay()
  , exports.wftda.constants.NTP_SAMPLE_TIME_IN_MS)
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