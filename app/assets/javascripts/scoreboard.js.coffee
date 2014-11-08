# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
exports = exports ? this
exports.wftda = exports.wftda ? {}
exports.wftda.classes = exports.wftda.classes ? {}
exports.wftda.functions = exports.wftda.functions ? {}
exports.wftda.constants = exports.wftda.constants ? {}
exports.wftda.constants.PERIOD_DURATION_IN_MS = 30*60*1000
exports.wftda.constants.JAM_DURATION_IN_MS = 2*60*1000
exports.wftda.constants.LINEUP_DURATION_IN_MS = 30*1000
exports.wftda.constants.TIMEOUT_DURATION_IN_MS = 30*1000
exports.wftda.functions.toClock = (time) ->
  sec = parseInt(time/1000, 10)
  hours   = Math.floor(sec / 3600)
  minutes = Math.floor((sec - (hours * 3600)) / 60)
  seconds = sec - (hours * 3600) - (minutes * 60)
  # if hours < 10
  #   hours = "0" + hours
  if minutes < 10
    minutes = "0" + minutes
  if seconds < 10
    seconds = "0" + seconds
  if hours > 0
    time = "#{hours}:"
  else
    time = "#{minutes}:#{seconds}"
  return time;
exports.wftda.classes.Scoreboard = class Scoreboard
  constructor: (options = {}) ->
    @jamClock = $("#jam-clock")
    @periodClock = $("#period-clock")
    @jamClockLabel = $("#jam-clock-label")
    @lastPeriodTick = null
    @lastJamTick = null
    exports.periodTickFunction = null
    exports.jamTickFunction = null
    @periodTime = exports.wftda.constants.PERIOD_DURATION_IN_MS
    @jamTime = exports.wftda.constants.JAM_DURATION_IN_MS
    @homeScore = 0
    @awayScore = 0
  startPeriodClock: () ->
    @lastPeriodTick = Date.now()
    exports.periodTickFunction = setInterval(() =>
      this.tickPeriodClock()
    ,250)
  startJamClock: () ->
    @lastJamTick = Date.now()
    exports.jamTickFunction = setInterval(() =>
      this.tickJamClock()
    ,250)
  stopClocks: () ->
    clearInterval(exports.periodTickFunction)
    clearInterval(exports.jamTickFunction)
  tickPeriodClock: () ->
    stopTime = Date.now()
    periodDelta = stopTime - @lastPeriodTick
    @lastPeriodTick = stopTime
    @periodTime = @periodTime - periodDelta
    @periodTime = 0 if @periodTime < 0
    @periodClock.html(exports.wftda.functions.toClock(@periodTime))
  tickJamClock: () ->
    stopTime = Date.now()
    jamDelta = stopTime - @lastJamTick
    @lastJamTick = stopTime
    @jamTime = @jamTime - jamDelta
    @jamTime = 0 if @jamTime < 0
    @jamClock.html(exports.wftda.functions.toClock(@jamTime))
  startJam: () ->
    @jamTime = exports.wftda.constants.JAM_DURATION_IN_MS
    this.startJamClock();
    this.startPeriodClock();
    @jamClockLabel.html("Jam")
  stopJam: () ->
    this.stopClocks()
    this.startLineupClock()
  startLineupClock: () ->
    @jamTime = exports.wftda.constants.LINEUP_DURATION_IN_MS
    this.startJamClock()
    @jamClockLabel.html("Lineup")
  setTimeToDerby: (time = 60*60*1000) ->
    @periodTime = time
    this.startPeriodClock()
  startOfficialTimeout: () ->
    this.stopClocks()
    @jamTime = 0
    this.startJamClock()
    @jamClockLabel.html("Official Timeout")
  startTeamTimeout: () ->
    @jamTime = exports.wftda.constants.LINEUP_DURATION_IN_MS
    this.startJamClock()
    @jamClockLabel.html("Team Timeout")
  incrementHomeTeamScore: (score = 1) ->
    @homeScore = @homeScore + score
  decrementHomeTeamScore: (score = 1) ->
    @homeScore = @homeScore - score
  incrementAwayTeamScore: (score = 1) ->
    @awayScore = @awayScore + score
  decrementAwayTeamScore: (score = 1) ->
    @awayScore = @awayScore - score
  restoreHomeTeamOfficialReview: () ->
  restoreAwayTeamOfficialReview: () ->
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
  setJamClock: () ->

  updateScore: (homeScore, awayScore)->
