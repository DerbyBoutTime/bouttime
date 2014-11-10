# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
exports = exports ? this
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
    @isTakingTimeout = false
    @isTakingOfficialReview = false
    @isUnofficialFinal = false
    @isOfficialFinal = false

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
    @jamClockLabelElement = $("#scoreboard .jam-clock label")
    @jamClockElement = $("#scoreboard .jam-clock .clock")
    @periodClockElement = $("#scoreboard .period-clock .clock")
    @homeTeamTimeoutElement = $("")
    @awayTeamTimeoutElement = $("")
    @homeTeamOfficialReviewElement = $("")
    @awayTeamOfficialReviewElement = $("")
    @homeTeamUnOfficialFinalElement = $("")
    @awayTeamUnOfficialFinalElement = $("")
    @homeTeamOfficialFinalElement= $("")
    @awayTeamOfficialFinalElement= $("")
    @home = new exports.wftda.classes.scoreboard.Team()
    @away = new exports.wftda.classes.scoreboard.Team()
    @homeDOM = new exports.wftda.classes.scoreboard.TeamDOM("#scoreboard .home-team","#scoreboard .home-team-jam-points")
    @homeDOM.initialize()
    @awayDOM = new exports.wftda.classes.scoreboard.TeamDOM("#scoreboard .away-team","#scoreboard .away-team-jam-points")
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
    this.clearTimeouts()
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
  startTimeout: () ->
    this.stopClocks()
    @jamTime = exports.wftda.constants.LINEUP_DURATION_IN_MS
    this.startJamClock()
    @jamClockLabel = "Timeout Clock"
  assignTimeoutToHomeTeam: () ->
    this.clearTimeouts()
    @jamClockLabel = "Team Timeout"
    @home.timeouts = @home.timeouts - 1
    @home.isTakingTimeout = true
  assignTimeoutToAwayTeam: () ->
    this.clearTimeouts()
    @jamClockLabel = "Team Timeout"
    @away.timeouts = @away.timeouts - 1
    @away.isTakingTimeout = true
  assignTimeoutToOfficials: () ->
    this.clearTimeouts()
    @jamTime = 0
    this.startJamClock()
    @jamClockLabel = "Official Timeout"
  assignTimeoutToHomeTeamOfficialReview: () ->
    this.clearTimeouts()
    @jamTime = 0
    this.startJamClock()
    @home.hasOfficialReview = false
    @home.isTakingOfficialReview = true
    @jamClockLabel = "Official Review"
  assignTimeoutToAwayTeamOfficialReview: () ->
    this.clearTimeouts()
    @jamTime = 0
    this.startJamClock()
    @away.hasOfficialReview = false
    @away.isTakingOfficialReview = true
    @jamClockLabel = "Official Review"
  incrementPeriodTime: () ->
  decrementPeriodTime: () ->
  undo: () ->

  updateScore: (homeScore, awayScore)->
  clearTimeouts: () ->
    @home.isTakingTimeout = false
    @away.isTakingTimeout = false
    @home.isTakingOfficialReview = false
    @away.isTakingOfficialReview = false

  paint: () ->
    @periodClockElement.html(exports.wftda.functions.toClock(@periodTime, 2))
    @jamClockLabelElement.html(@jamClockLabel)
    @jamClockElement.html(exports.wftda.functions.toClock(@jamTime, 2))
    @homeDOM.score.html(@home.score)
    @awayDOM.score.html(@away.score)
    @homeDOM.timeouts.find(".timeout-bar").removeClass("active")
    @awayDOM.timeouts.find(".timeout-bar").removeClass("active")
    if @home.isTakingTimeout
      @homeDOM.timeouts.find(".timeout").eq(@home.timeouts).addClass("active")
    if @home.isTakingOfficialReview
      @homeDOM.timeouts.find(".official-review").first().addClass("active")
    @homeDOM.timeouts.find(".timeout").slice(@home.timeouts).addClass("inactive")
    if @away.isTakingTimeout
      @awayDOM.timeouts.find(".timeout").eq(@away.timeouts).addClass("active")
    if @away.isTakingOfficialReview
      @awayDOM.timeouts.find(".official-review").first().addClass("active")
    @awayDOM.timeouts.find(".timeout").slice(@away.timeouts).addClass("inactive")
    if @away.hasOfficialReview == false
      @awayDOM.timeouts.find(".official-review").first().addClass("inactive")
    if @home.hasOfficialReview == false
      @homeDOM.timeouts.find(".official-review").first().addClass("inactive")
#$(document).on "page:change", exports.wftda.functions.bindScoreboardKeys
$(document).on "page:change", exports.wftda.functions.bindScoreboardKeysCRG
