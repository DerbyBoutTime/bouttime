# Legacy version 1.0 of the scoreboard pre-react
exports = exports ? this
exports.wftda.functions.bindScoreboardKeys = () ->
  scoreboard = new wftda.classes.Scoreboard()
  scoreboard.initialize()
  exports.wftda.components.scoreboard = scoreboard
  #TBD
exports.wftda.functions.bindScoreboardKeysCRG = () ->
  scoreboard = new wftda.classes.Scoreboard()
  scoreboard.initialize()
  exports.wftda.components.scoreboard = scoreboard
  #Toggle Jam Clock
  Mousetrap.bind 'space', () ->
    scoreboard.toggleJamClock()
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
  Mousetrap.bind ['>','shift+alt+right'], () ->
    scoreboard.incrementPeriodTime()
  Mousetrap.bind 'shift+alt+up', () ->
    scoreboard.incrementPeriodTime(10000)
  #Period Time Down
  Mousetrap.bind ['<','shift+alt+left'], () ->
    scoreboard.decrementPeriodTime()
  Mousetrap.bind 'shift+alt+down', () ->
    scoreboard.decrementPeriodTime(10000)
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
  #Period Up
  Mousetrap.bind 'shift+up', () ->
    scoreboard.incrementPeriodNumber()
  #Period Down
  Mousetrap.bind 'shift+down', () ->
    scoreboard.decrementPeriodNumber()
  #Jam Up
  Mousetrap.bind 'shift+right', () ->
    scoreboard.incrementJamNumber()
  #Jam Down
  Mousetrap.bind 'shift+left', () ->
    scoreboard.decrementJamNumber()
  #Unofficial Final
  Mousetrap.bind 'shift+enter', () ->
    scoreboard.setUnofficialFinal()
 #Official Final
  Mousetrap.bind 'shift+ctrl+enter', () ->
    scoreboard.setOfficialFinal()
#Clear Alerts
  Mousetrap.bind 'shift+backspace', () ->
    scoreboard.clearAlerts()
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
    @jammer = @jammer || @base.find(".jammer .name").first()
    @lead = @lead || @base.find(".jammer .lead-status").first()
    @timeouts = @timeouts || @base.children(".timeouts").first()
    @officialReview = @officialReview || @timeouts.children(".official-review-bar").first
exports.wftda.classes.Scoreboard = class Scoreboard
  constructor: (@baseSelector = "#scoreboard") ->
    @base = $("#{@baseSelector}")
    @id = exports.wftda.functions.uniqueId()
    @jamClockLabelElement = @base.find(".jam-clock label").first()
    @jamClockElement = @base.find(".jam-clock .clock").first()
    @periodClockElement = @base.find(".period-clock .clock").first()
    @jamNumberElement = @base.find(".jam-number").first()
    @periodNumberElement = @base.find(".period-number").first()
    @alerts = @base.find(".alerts").first()
    @homeTeamTimeoutElement = @alerts.find(".home-team-timeout").first()
    @awayTeamTimeoutElement = @alerts.find(".away-team-timeout").first()
    @homeTeamOfficialReviewElement = @alerts.find(".home-team-official-review").first()
    @awayTeamOfficialReviewElement = @alerts.find(".away-team-official-review").first()
    @homeTeamUnOfficialFinalElement = @alerts.find(".home-team-unofficial-final").first()
    @awayTeamUnOfficialFinalElement = @alerts.find(".away-team-unofficial-final").first()
    @homeTeamOfficialFinalElement= @alerts.find(".home-team-final").first()
    @awayTeamOfficialFinalElement= @alerts.find(".away-team-final").first()
    @globalTimeoutElement = @alerts.find(".generic-timeout").first()
    @globalOfficialTimeoutElement = @alerts.find(".official-timeout").first()
    @globalUnOfficialFinalElement = @alerts.find(".unofficial-final").first()
    @globalOfficialFinalElement = @alerts.find(".official-final").first()
    @home = new exports.wftda.classes.scoreboard.Team()
    @away = new exports.wftda.classes.scoreboard.Team()
    @homeDOM = new exports.wftda.classes.scoreboard.TeamDOM("#{@baseSelector} .home-team","#{@baseSelector} .home-team-jam-points")
    @homeDOM.initialize()
    @awayDOM = new exports.wftda.classes.scoreboard.TeamDOM("#{@baseSelector} .away-team","#{@baseSelector} .away-team-jam-points")
    @awayDOM.initialize()
  initialize: () ->
    @lastPeriodTick = null
    @lastJamTick = null
    exports.wftda.ticks[@id] = exports.wftda.ticks[@id] || {}
    @stopPeriodClock()
    @stopJamClock()
    @periodTime = 0 #exports.wftda.constants.PERIOD_DURATION_IN_MS
    @jamTime = exports.wftda.constants.JAM_DURATION_IN_MS
    @home.score = @away.score = 0
    @home.timeouts = @away.timeouts = 3
    @home.hasOfficialReview = @away.hasOfficialReview = true
    @home.hasOfficialReviewsRetained = @away.hasOfficialReviewsRetained = 0
    @home.jammer.name = @away.jammer.name = ""
    @inTimeout = false
    @inOfficialTimeout = false
    @inUnofficialFinal = false
    @inOfficialFinal = false
    @period = 0
    @jam = 0
    @lastHeartbeat = null
    @setTimeToDerby(1000*60*60)
    @paint()
  setUnofficialFinal: () ->
    @inUnofficialFinal = true
    @inOfficialFinal =  false
  setOfficialFinal: () ->
    @inUnofficialFinal = false
    @inOfficialFinal =  true
  receiveHeartbeat: (evt, data) ->
    @lastHeartbeat = evt.timestamp
  startPeriodClock: () ->
    @stopPeriodClock() #Clear to prevent lost interval function
    @lastPeriodTick = Date.now()
    exports.wftda.ticks[@id].periodTickFunction = setInterval(() =>
      @tickperiodClock()
    ,exports.wftda.constants.CLOCK_REFRESH_RATE_IN_MS)
  toggleJamClock: () ->
    if exports.wftda.ticks[@id].jamTickFunction == null
      @startJamClock()
    else
      @stopJamClock()
  startJamClock: () ->
    @stopJamClock() #Clear to prevent lost interval function
    @lastJamTick = Date.now()
    exports.wftda.ticks[@id].jamTickFunction = setInterval(() =>
      @tickjamClock()
    ,exports.wftda.constants.CLOCK_REFRESH_RATE_IN_MS)
  stopClocks: () ->
    @stopJamClock()
    @stopPeriodClock()
  isPeriodClockRunning: () ->
    exports.wftda.ticks[@id].periodTickFunction != null
  isJamClockRunning: () ->
    exports.wftda.ticks[@id].jamTickFunction != null
  stopJamClock: () ->
    clearInterval exports.wftda.ticks[@id].jamTickFunction
    exports.wftda.ticks[@id].jamTickFunction = null
  stopPeriodClock: () ->
    clearInterval exports.wftda.ticks[@id].periodTickFunction
    exports.wftda.ticks[@id].periodTickFunction = null
  tickperiodClock: () ->
    stopTime = Date.now()
    periodDelta = stopTime - @lastPeriodTick
    @lastPeriodTick = stopTime
    @periodTime = @periodTime - periodDelta
    @periodTime = 0 if @periodTime < 0
    @base.trigger "periodTick",
      timestamp: @lastPeriodTick
      displayTime: @formatPeriodClock()
  tickjamClock: () ->
    stopTime = Date.now()
    jamDelta = stopTime - @lastJamTick
    @lastJamTick = stopTime
    @jamTime = @jamTime - jamDelta
    @jamTime = 0 if @jamTime < 0
    @base.trigger "jamTick",
      timestamp: @lastJamTick
      displayTime: @formatJamClock()
      displayLabel: @jamClockLabel
  clearJammers: () ->
    @home.jammer = new exports.wftda.classes.scoreboard.Jammer()
    @away.jammer = new exports.wftda.classes.scoreboard.Jammer()
  startJam: () ->
    @clearTimeouts()
    @clearJammers()
    @jamTime = exports.wftda.constants.JAM_DURATION_IN_MS
    @startJamClock()
    @startPeriodClock()
    @jamClockLabel = "Jam Clock"
    @home.jamPoints = 0
    @away.jamPoints = 0
    @jam = @jam + 1
  stopJam: () ->
    @stopClocks()
    @startLineupClock()
  startLineupClock: () ->
    @clearTimeouts()
    @jamTime = exports.wftda.constants.LINEUP_DURATION_IN_MS
    @startJamClock()
    @jamClockLabel = "Lineup Clock"
  setTimeToDerby: (time = 60*60*1000) ->
    @periodTime = 0
    @jamClockLabel = "Time To Derby"
    @jamTime = time
  incrementHomeTeamScore: (score = 1) ->
    score = parseInt(score)
    @home.score = @home.score + score
    @home.jamPoints = @home.jamPoints + score
  decrementHomeTeamScore: (score = 1) ->
    score = parseInt(score)
    @home.score = @home.score - score
    @home.jamPoints = @home.jamPoints - score
  incrementAwayTeamScore: (score = 1) ->
    score = parseInt(score)
    @away.score = @away.score + score
    @away.jamPoints = @away.jamPoints + score
  decrementAwayTeamScore: (score = 1) ->
    score = parseInt(score)
    @away.score = @away.score - score
    @away.jamPoints = @away.jamPoints - score
  restoreHomeTeamOfficialReview: () ->
    @home.hasOfficialReview = true
  restoreAwayTeamOfficialReview: () ->
    @home.hasOfficialReview = true
  setHomeTeamName: (name) ->
    @home.name = name
  setAwayTeamName: (name) ->
    @away.name = name
  setHomeTeamJammer: (name) ->
    @home.jammer.name = name
  setAwayTeamJammer: (name) ->
    @away.jammer.name = name
  setHomeTeamLead: () ->
    @home.jammer.lead = true
  setAwayTeamLead: () ->
    @away.jammer.lead = true
  setHomeTeamNotLead: () ->
    @home.jammer.lead = false
  setAwayTeamNotLead: () ->
    @away.jammer.lead = false
  incrementPeriodNumber: (num = 1) ->
    @period = @period + parseInt(num)
  decrementPeriodNumber: (num = 1) ->
    @period = @period - parseInt(num)
  setPeriod: (num) ->
    @period = parseInt(num)
  incrementJamNumber: (num = 1) ->
    @jam = @jam + parseInt(num)
  decrementJamNumber: (num = 1) ->
    @jam = @jam - parseInt(num)
  setJamNumber: (num) ->
    @jam = parseInt(num)
  startTimeout: () ->
    @inTimeout = true
    @stopClocks()
    @jamTime = exports.wftda.constants.LINEUP_DURATION_IN_MS
    @startJamClock()
    @jamClockLabel = "Timeout Clock"
  assignTimeoutToHomeTeam: () ->
    if @inTimeout == false
      @startTimeout()
    @clearTimeouts()
    @inTimeout = true
    @jamClockLabel = "Team Timeout"
    @home.timeouts = @home.timeouts - 1
    @home.isTakingTimeout = true
    @undoFunction = @restoreHomeTeamTimeout
  restoreHomeTeamTimeout: () ->
    @home.timeouts = @home.timeouts + 1
    @clearTimeouts()
  assignTimeoutToAwayTeam: () ->
    if @inTimeout == false
      @startTimeout()
    @clearTimeouts()
    @inTimeout = true
    @jamClockLabel = "Team Timeout"
    @away.timeouts = @away.timeouts - 1
    @away.isTakingTimeout = true
    @undoFunction = @restoreAwayTeamTimeout
  restoreAwayTeamTimeout: () ->
    @away.timeouts = @away.timeouts + 1
    @clearTimeouts()
  assignTimeoutToOfficials: () ->
    if @inTimeout == false
      @startTimeout()
    @clearTimeouts()
    @jamTime = 0
    @stopJamClock()
    @jamClockLabel = "Official Timeout"
    @inOfficialTimeout = true
    @inTimeout = true
  assignTimeoutToHomeTeamOfficialReview: () ->
    if @inTimeout == false
      @startTimeout()
    @clearTimeouts()
    @jamTime = 0
    @startJamClock()
    @inTimeout = true
    @home.hasOfficialReview = false
    @home.isTakingOfficialReview = true
    @jamClockLabel = "Official Review"
    @undoFunction = @restoreHomeTeamOfficialReview
  restoreHomeTeamOfficialReview: (retained = false) ->
    @home.hasOfficialReview = true
    @clearTimeouts()
    if retained
      @home.officialReviewsRetained = @home.officialReviewsRetained + 1
  assignTimeoutToAwayTeamOfficialReview: () ->
    if @inTimeout == false
      @startTimeout()
    @clearTimeouts()
    @jamTime = 0
    @startJamClock()
    @inTimeout = true
    @away.hasOfficialReview = false
    @away.isTakingOfficialReview = true
    @jamClockLabel = "Official Review"
    @undoFunction = @restoreAwayTeamOfficialReview
  restoreAwayTeamOfficialReview: (retained = false) ->
    @away.hasOfficialReview = true
    @clearTimeouts()
    if retained
      @away.officialReviewsRetained = @away.officialReviewsRetained + 1
  incrementPeriodTime: (ms = 1000) ->
    @periodTime = @periodTime + ms
  decrementPeriodTime: (ms = 1000) ->
    @periodTime = @periodTime - ms
  clearAlerts: () ->
    @clearTimeouts()
    @inUnofficialFinal = false
    @inOfficialFinal = false
    @home.isUnofficialFinal = false
    @home.isOfficialFinal = false
    @away.isUnofficialFinal = false
    @away.isOfficialFinal = false
  clearTimeouts: () ->
    @home.isTakingTimeout = false
    @away.isTakingTimeout = false
    @home.isTakingOfficialReview = false
    @away.isTakingOfficialReview = false
    @inTimeout = false
    @inOfficialTimeout = false
  formatJamClock: () ->
    exports.wftda.functions.toClock(@jamTime, 2)
  formatPeriodClock: () ->
    exports.wftda.functions.toClock(@periodTime, 2)
  paint: () ->
    #Period Clock
    @periodClockElement.html(@formatPeriodClock())
    #Jam Clock
    @jamClockLabelElement.html(@jamClockLabel)
    @jamClockElement.html(@formatJamClock())
    #Jam Points
    @homeDOM.jamPoints.html(@home.jamPoints)
    @awayDOM.jamPoints.html(@away.jamPoints)
    #Jam Number
    @jamNumberElement.html(@jam)
    #Period Number
    @periodNumberElement.html(@period)
    #Team Logos
    if @home.logoUrl?
      @homeDOM.logo.html """
      <img src='#{@home.logoUrl}' />
      """
      @home.logoUrl == null
    if @away.logoUrl?
      @awayDOM.logo.html """
      <img src='#{@away.logoUrl}' />
      """
      @away.logoUrl == null
    #Team Names
    @homeDOM.name.html(@home.name)
    @awayDOM.name.html(@away.name)
    #Team Scores
    @homeDOM.score.html(@home.score)
    @awayDOM.score.html(@away.score)
    #Jammer Name
    if /s+/.test @home.jammer.name
      @homeDOM.jammer.html(@home.jammer.name)
    if /s+/.test @away.jammer.name
      @awayDOM.jammer.html(@away.jammer.name)
    #Jammer Lead
    if @home.jammer.lead
      @homeDOM.lead.removeClass("hidden")
    else
      @homeDOM.lead.addClass("hidden")
    if @away.jammer.lead
      @awayDOM.lead.removeClass("hidden")
    else
      @awayDOM.lead.addClass("hidden")
    ###
    Team Timeouts & Team Official Review Icons
    ###
    @homeDOM.timeouts.find(".timeout-bar").removeClass("active")
    @awayDOM.timeouts.find(".timeout-bar").removeClass("active")
    if @home.isTakingTimeout
      @homeDOM.timeouts.find(".timeout").eq(@home.timeouts).addClass("active")
    if @home.isTakingOfficialReview
      @homeDOM.timeouts.find(".official-review").first().addClass("active")
    @homeDOM.timeouts.find(".timeout").removeClass("inactive")
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
    #Hide all existing notifications
    @alerts.find(".scoreboard-alert").addClass("hidden")
    #Team Timeout Notifications
    if @home.isTakingTimeout
      @homeTeamTimeoutElement.removeClass("hidden")
    else if @away.isTakingTimeout
      @awayTeamTimeoutElement.removeClass("hidden")
    #Team Official Review Notification
    else if @home.isTakingOfficialReview
      @homeTeamOfficialReviewElement.removeClass("hidden")
    else if @away.isTakingOfficialReview
      @awayTeamOfficialReviewElement.removeClass("hidden")
    #Official Timeout
    else if @inOfficialTimeout
      @globalOfficialTimeoutElement.removeClass("hidden")
    #Generic Timeout
    else if @inTimeout
      @globalTimeoutElement.removeClass("hidden")
    #Unofficial Final
    if @inUnofficialFinal
      @globalUnOfficialFinalElement.removeClass("hidden")
    #Official Final
    else if @inOfficialFinal
      @globalOfficialFinalElement.removeClass("hidden")
    #Call Recursively
    requestAnimationFrame @paint.bind(this)
  updateScore: (homeScore, awayScore) ->
    @home.score = parseInt(homeScore)
    @away.score = parseInt(awayScore)
  setHomeTeamLogo: (logoUrl) ->
    @home.logoUrl = logoUrl
  setAwayTeamLogo: (logoUrl) ->
    @away.logoUrl = logoUrl
  undo: () ->
    @undoFunction()
#$(document).on "page:change", exports.wftda.functions.bindScoreboardKeys
$(document).on "page:change", exports.wftda.functions.bindScoreboardKeysCRG