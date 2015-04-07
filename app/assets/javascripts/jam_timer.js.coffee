exports = exports ? this
exports.classes = exports.classes ? {}
exports.classes.JamTimer = class JamTimer
  constructor: (gameState) ->
  update: (newState) ->
  serialize: () ->
  startJam: () ->
    @_clearTimeouts()
    @_clearJammers()
    @clockManager.getClock("jamClock").reset(exports.wftda.constants.JAM_DURATION_IN_MS)
    @clockManager.getClock("jamClock").start()
    @clockManager.getClock("periodClock").start()
    @state = "jam"
    @homeAttributes.jamPoints = 0
    @awayAttributes.jamPoints = 0
    if @clockManager.getClock("periodClock").time == 0
      @periodNumber = @periodNumber + 1
      @clockManager.getClock("periodClock").reset(exports.wftda.constants.PERIOD_DURATION_IN_MS)
    @jamNumber = @jamNumber + 1
    for i in [@awayAttributes.jamStates.length+1 .. @jamNumber] by 1
      @awayAttributes.jamStates.push jamNumber: i
    for i in [@homeAttributes.jamStates.length+1 .. @jamNumber] by 1
      @homeAttributes.jamStates.push jamNumber: i
  stopJam: () ->
  startLineup: () ->
  startPregame: () ->
  startHalftime: () ->
  startUnofficialFinal: () ->
  startOfficialFinal: () ->
  startTimeout: () ->
  setTimeoutAsOfficialTimeout: () ->
  setTimeoutAsHomeTeamTimeout: () ->
  setTimeoutAsHomeTeamOfficialReview: () ->
  setTimeoutAsAwayTeamTimeout: () ->
  setTimeoutAsAwayTeamOfficialReview: () ->
  setJamEndedByTime: () ->
  setJamEndedByCalloff: () ->
  setJamClockToTime: () ->
  setPeriodClockToTime: () ->
  setHomeTeamTimeouts: () ->
  setAwayTeamTimeouts: () ->
  setPeriodNumber: () ->
  setJamNumber: () ->
  restoreOfficialReview: () ->