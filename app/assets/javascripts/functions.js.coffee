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
exports.wftda.functions.toClock = (time, significantSections = 1, partialSeconds = false, includeLeadingZeros = true) ->
  sec = parseInt(time/1000, 10)
  milliseconds = parseInt(time % 1000, 10)
  hours = minutes = seconds = 0
  if significantSections >= 3
    hours = Math.floor(sec / 3600)
  if significantSections >=2
    minutes = Math.floor((sec - (hours * 3600)) / 60)
  if significantSections >=1
    seconds = sec - (hours * 3600) - (minutes * 60)

  #Padding
  # if includeLeadingZeros == true

  #Only Display signfication Sections
  strTime = ""
  if (includeLeadingZeros || hours > 0) && significantSections >=3
    strTime = "#{exports.wftda.functions.pad(hours,2)}:"
  if (includeLeadingZeros || minutes > 0) && significantSections >=2
    strTime = strTime + "#{exports.wftda.functions.pad(minutes,2)}:"
  if significantSections >= 1
    strTime = strTime + "#{exports.wftda.functions.pad(seconds,2)}"
  if partialSeconds == true
    strTime = strTime + ".#{exports.wftda.functions.pad(milliseconds, 3)}"
  return strTime