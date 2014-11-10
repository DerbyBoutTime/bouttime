# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
exports = exports ? this
exports.wftda = exports.wftda ? {}
exports.wftda.classes = exports.wftda.classes ? {}
exports.wftda.ticks = exports.wftda.ticks ? {}
exports.wftda.functions = exports.wftda.functions ? {}
exports.wftda.components = exports.wftda.components ? {}
exports.wftda.constants = exports.wftda.constants ? {}
exports.wftda.constants.PERIOD_DURATION_IN_MS = 30*60*1000
exports.wftda.constants.JAM_DURATION_IN_MS = 2*60*1000
exports.wftda.constants.LINEUP_DURATION_IN_MS = 30*1000
exports.wftda.constants.TIMEOUT_DURATION_IN_MS = 30*1000
exports.wftda.constants.CLOCK_REFRESH_RATE_IN_MS = 125
exports.wftda.constants.PAINT_RATE_IN_MS = 16
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
  Mousetrap.bind '<', () ->
    scoreboard.incrementPeriodTime()
  #Period Time Down
  Mousetrap.bind '>', () ->
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

exports.wftda.classes.scoreboard = exports.wftda.classes.scoreboards ? {}
exports.wftda.classes.scoreboard.Jammer = class Jammer
  constructor: () ->
    @name = @number = ""
    @lead = false

exports.wftda.classes.scoreboard.Team = class Team
  constructor: () ->
    @logoUrl = ""
    @name = ""
    @score = 0
    @jammer = new exports.wftda.classes.scoreboard.Jammer()
    @timeouts = 3
    @hasOfficialReview = true
    @officialReviewsRetained = 0
    @jamPoints = 0

exports.wftda.classes.scoreboard.TeamDOM = class TeamDOM
  constructor: (@sectionSelector, @jamPointsSelector, @logo, @name, @score, @jammer, @lead, @timeouts, @officialReview) ->
    @base = $(sectionSelector)
    @jamPoints = $(jamPointsSelector)
  initialize: () ->
    @logo = @logo || @base.children(".logo").first()
    @name = @name || @base.children(".name").first()
    @score = @score || @base.children(".score").first()
    @jammer = @jammer || @base.children(".jammer .name").first()
    @lead = @lead || @base.children(".jammer .lead-status").first()
    @timeouts = @timeouts || @base.children(".timeouts").first()
    @officialReview = @officialReview || @timeouts.children(".official-review-bar").first

exports.wftda.classes.Scoreboard = class Scoreboard
  constructor: (options = {}) ->
    @id = exports.wftda.functions.uniqueId()
    @jamClockLabelElement = $("#jam-clock-label")
    @jamClockElement = $("#jam-clock")
    @periodClockElement = $("#period-clock")
    @home = new exports.wftda.classes.scoreboard.Team()
    @away = new exports.wftda.classes.scoreboard.Team()
    @homeDOM = new exports.wftda.classes.scoreboard.TeamDOM("#home-team","#home-team-jam-points")
    @homeDOM.initialize()
    @awayDOM = new exports.wftda.classes.scoreboard.TeamDOM("#away-team","#away-team-jam-points")
    @awayDOM.initialize()
  initialize: () ->
    @lastPeriodTick = null
    @lastJamTick = null
    exports.wftda.ticks[@id] = exports.wftda.ticks[@id] || {}
    clearInterval(exports.wftda.ticks[@id].periodTickFunction)
    clearInterval(exports.wftda.ticks[@id].jamTickFunction)
    clearInterval(exports.wftda.ticks[@id].scoreboardPaintTickFunction)
    exports.wftda.ticks[@id].periodTickFunction = null
    exports.wftda.ticks[@id].jamTickFunction = null
    exports.wftda.ticks[@id].scoreboardPaintTickFunction = setInterval(() =>
      this.paint()
    ,exports.wftda.constants.PAINT_RATE_IN_MS)
    @periodTime = exports.wftda.constants.PERIOD_DURATION_IN_MS
    @jamTime = exports.wftda.constants.JAM_DURATION_IN_MS
    @home.score = @away.score = 0
    @home.timeouts = @away.timeouts = 3
    @home.hasOfficialReview = @away.hasOfficialReview = true
    @home.hasOfficialReviewsRetained = @away.hasOfficialReviewsRetained = 0
    @home.jammer.name = @away.jammer.name = ""
    @jamClockLabel = "Time to Derby"
    @jamTime = 1000*60*90
    @genericTimeout = false
    @officialTimeout = false
    @unofficialFinal = false
    @officialFinal = false
  startPeriodClock: () ->
    this.stopPeriodClock() #Clear to prevent lost interval function
    @lastPeriodTick = Date.now()
    exports.wftda.ticks[@id].periodTickFunction = setInterval(() =>
      this.tickperiodClock()
    ,exports.wftda.constants.CLOCK_REFRESH_RATE_IN_MS)
  startJamClock: () ->
    this.stopJamClock() #Clear to prevent lost interval function
    @lastJamTick = Date.now()
    exports.wftda.ticks[@id].jamTickFunction = setInterval(() =>
      this.tickjamClock()
    ,exports.wftda.constants.CLOCK_REFRESH_RATE_IN_MS)
  stopClocks: () ->
    this.stopJamClock()
    this.stopPeriodClock()
  stopJamClock: () ->
    clearInterval(exports.wftda.ticks[@id].jamTickFunction)
  stopPeriodClock: () ->
    clearInterval(exports.wftda.ticks[@id].periodTickFunction)
  tickperiodClock: () ->
    stopTime = Date.now()
    periodDelta = stopTime - @lastPeriodTick
    @lastPeriodTick = stopTime
    @periodTime = @periodTime - periodDelta
    @periodTime = 0 if @periodTime < 0
  tickjamClock: () ->
    stopTime = Date.now()
    jamDelta = stopTime - @lastJamTick
    @lastJamTick = stopTime
    @jamTime = @jamTime - jamDelta
    @jamTime = 0 if @jamTime < 0
  startJam: () ->
    @jamTime = exports.wftda.constants.JAM_DURATION_IN_MS
    this.startJamClock()
    this.startPeriodClock()
    @jamClockLabel = "Jam Clock"
  stopJam: () ->
    this.stopClocks()
    this.startLineupClock()
  startLineupClock: () ->
    @jamTime = exports.wftda.constants.LINEUP_DURATION_IN_MS
    this.startJamClock()
    @jamClockLabel = "Lineup Clock"
  setTimeToDerby: (time = 60*60*1000) ->
    @periodTime = time
    this.startPeriodClock()
  startTimeout: () ->
    this.stopClocks()
    @jamTime = exports.wftda.constants.LINEUP_DURATION_IN_MS
    this.startJamClock()
    @jamClockLabel = "Timeout Clock"
  incrementHomeTeamScore: (score = 1) ->
    @home.score = @home.score + score
  decrementHomeTeamScore: (score = 1) ->
    @home.score = @home.score - score
  incrementAwayTeamScore: (score = 1) ->
    @away.score = @away.score + score
  decrementAwayTeamScore: (score = 1) ->
    @away.score = @away.score - score
  restoreHomeTeamOfficialReview: () ->
    @home.hasOfficialReview = 1
  restoreAwayTeamOfficialReview: () ->
    @home.hasOfficialReview = 1
  setHomeTeamJammer: () ->
  setAwayTeamJammer: () ->
  setHomeTeamLead: () ->
  setAwayTeamLead: () ->
  setHomeTeamNotLead: () ->
  setAwayTeamNotLead: () ->
  incrementPeriod: () ->
  decrementPeriod: () ->
  setPeriod: () ->
  incrementJamNumber: () ->
  decrementJamNumber: () ->
  setJamNumber: () ->
  setGameClock: () ->
  setjamClockElement: () ->
  assignTimeoutToHomeTeam: () ->
    @jamClockLabel = "Team Timeout"
  assignTimeoutToAwayTeam: () ->
    @jamClockLabel = "Team Timeout"
  assignTimeoutToOfficials: () ->
    @jamTime = 0
    this.startJamClock()
    @jamClockLabel = "Official Timeout"
  incrementPeriodTime: () ->
  decrementPeriodTime: () ->
  undo: () ->

  updateScore: (homeScore, awayScore)->
  paint: () ->
    @periodClockElement.html(exports.wftda.functions.toClock(@periodTime, 2))
    @jamClockLabelElement.html(@jamClockLabel)
    @jamClockElement.html(exports.wftda.functions.toClock(@jamTime, 2))
    @homeDOM.score.html(@home.score)
    @awayDOM.score.html(@away.score)

#$(document).on "page:change", exports.wftda.functions.bindScoreboardKeys
$(document).on "page:change", exports.wftda.functions.bindScoreboardKeysCRG

jQuery ->
  $(".scoreboard-alert:first").removeClass("hidden")