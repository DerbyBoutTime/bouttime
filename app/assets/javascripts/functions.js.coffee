exports = exports ? this
exports.wftda.functions.uniqueId = (length=8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length
exports.wftda.functions.pad = (num, digits) ->
  if num.toString().length < digits
    ("000" + num).substr(-digits)
  else
    num
# Take time in seconds and offset in milliseconds and formats it as a string
exports.wftda.functions.toClock = (time, offset = null) ->
  hours = minutes = seconds = 0
  hours = Math.floor(time / 3600)
  minutes = Math.floor((time % 3600) / 60)
  seconds = time % 60
  #Only Display signfication Sections
  strTime = ""
  if hours > 0
    strTime = "#{exports.wftda.functions.pad(hours,2)}:"
  if minutes > 0
    strTime = strTime + "#{exports.wftda.functions.pad(minutes,2)}:"
  strTime = strTime + "#{exports.wftda.functions.pad(seconds,2)}"
  if offset?
    strTime = strTime + ".#{exports.wftda.functions.pad(offset, 3)}"
  return strTime