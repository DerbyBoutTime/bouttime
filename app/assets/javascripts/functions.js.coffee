exports = exports ? this
exports.wftda.functions.uniqueId = (length=8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length
exports.wftda.functions.bindScoreboardKeys = () ->
  scoreboard = new wftda.classes.Scoreboard()
  scoreboard.initialize()
  exports.wftda.components.scoreboard = scoreboard
  #TBD
exports.wftda.functions.bindScoreboardKeysCRG = () ->
  scoreboard = new wftda.classes.Scoreboard()
  scoreboard.initialize()
  exports.wftda.components.scoreboard = scoreboard
  #Jam Start
  Mousetrap.bind 'j', () ->
    scoreboard.startJam()
  #Jam End
  Mousetrap.bind 'f', () ->
    scoreboard.stopJam()
  #Timeout
  Mousetrap.bind 'h', () ->
    scoreboard.startTimeout()
  #Period Time Up
  Mousetrap.bind '>', () ->
    scoreboard.incrementPeriodTime()
  #Period Time Down
  Mousetrap.bind '<', () ->
    scoreboard.decrementPeriodTime()
  #Home Team Score +
  Mousetrap.bind 'a', () ->
    scoreboard.incrementHomeTeamScore()
  #Home Team Score -
  Mousetrap.bind 's', () ->
    scoreboard.decrementHomeTeamScore()
  #Home Team Lead
  Mousetrap.bind 'd', () ->
    scoreboard.setHomeTeamLead()
  #Home Team Not Lead
  Mousetrap.bind 'e', () ->
    scoreboard.setHomeTeamNotLead()
  #Home Team Timeout
  Mousetrap.bind 't', () ->
    scoreboard.assignTimeoutToHomeTeam()
  #Home Team Official Review
  Mousetrap.bind 'r', () ->
    scoreboard.assignTimeoutToHomeTeamOfficialReview()
  #Away Team Score +
  Mousetrap.bind ';', () ->
    scoreboard.incrementAwayTeamScore()
  #Away Team Score -
  Mousetrap.bind 'l', () ->
    scoreboard.decrementAwayTeamScore()
  #Away Team Lead
  Mousetrap.bind 'k', () ->
    scoreboard.setAwayTeamLead()
  #Away Team Not Lead
  Mousetrap.bind 'i', () ->
    scoreboard.setAwayTeamNotLead()
  #Away Team Timeout
  Mousetrap.bind 'y', () ->
    scoreboard.assignTimeoutToAwayTeam()
  #Away Team Official Review
  Mousetrap.bind 'u', () ->
    scoreboard.assignTimeoutToAwayTeamOfficialReview()
  #Official Timeout
  Mousetrap.bind 'o', () ->
    scoreboard.assignTimeoutToOfficials()
  #Undo
  Mousetrap.bind 'z', () ->
    scoreboard.undo()
exports.wftda.functions.toClock = (time, significantSections = 1) ->
  sec = parseInt(time/1000, 10)
  hours = minutes = seconds = 0
  if significantSections >= 3
    hours = Math.floor(sec / 3600)
  if significantSections >=2
    minutes = Math.floor((sec - (hours * 3600)) / 60)
  if significantSections >=1
    seconds = sec - (hours * 3600) - (minutes * 60)

  #Add leading zeros
  if significantSections >= 4 && hours < 10
    hours = "0" + hours
  if significantSections >= 3 && minutes < 10
    minutes = "0" + minutes
  if significantSections >= 2 && seconds < 10
    seconds = "0" + seconds

  #Only Display signfication Sections
  strTime = ""
  if hours > 0 || significantSections >=3
    strTime = "#{hours}:"
  if minutes > 0 || significantSections >=2
    strTime = strTime + "#{minutes}:"
  if significantSections >= 1
    strTime = strTime + "#{seconds}"
  return strTime