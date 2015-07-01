functions = require '../functions'
constants = require '../constants'
seedrandom = require 'seedrandom'
Promise = require 'bluebird'
AppDispatcher = require '../dispatcher/app_dispatcher'
ActionTypes = constants.ActionTypes
{ClockManager} = require '../clock'
Store = require './store'
Jam = require './jam'
Skater = require './skater'
PENALTY_CLOCK_SETTINGS =
  time: constants.PENALTY_DURATION_IN_MS
  warningTime: constants.PENALTY_WARNING_IN_MS
class Team extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.CREATE_NEXT_JAM
        @find(action.teamId).then (team) =>
          team.createJamsThrough(action.jamNumber)
          team.save()
      when ActionTypes.TOGGLE_LEFT_EARLY
        @find(action.teamId).then (team) =>
          team.toggleLeftEarly(action.boxIndex)
          team.save()
      when ActionTypes.TOGGLE_PENALTY_SERVED
        @find(action.teamId).then (team) =>
          team.toggleServed(action.boxIndex)
          team.save()
      when ActionTypes.SET_PENALTY_BOX_SKATER
        @find(action.teamId).then (team) =>
          team.setPenaltyBoxSkater(action.boxIndexOrPosition, action.clockId, action.skaterId)
          team.save()
      when ActionTypes.ADD_PENALTY_TIME
        @find(action.teamId).then (team) =>
          team.addPenaltyTime(action.boxIndex)
          team.save()
      when ActionTypes.TOGGLE_PENALTY_TIMER
        @find(action.teamId).then (team) =>
          team.togglePenaltyTimer(action.boxIndex)
          team.save()
      when ActionTypes.TOGGLE_ALL_PENALTY_TIMERS
        @find(action.teamId).then (team) =>
          team.toggleAllPenaltyTimers()
          team.save()
      when ActionTypes.REMOVE_JAM
        AppDispatcher.waitFor [Jam.dispatchToken]
        .spread (jam) =>
          @find(jam.teamId)
        .then (team) =>
          team.renumberJams()
          team.save()
  constructor: (options={}) ->
    super options
    @name = options.name
    @initials = options.initials
    @colorBarStyle = options.colorBarStyle ? { backgroundColor: '', color: '' }
    @colorBarStyle.borderColor = @colorBarStyle.backgroundColor
    @logo = options.logo
    @officialReviewsRetained = options.officialReviewsRetained ? 0
    @isTakingOfficialReview = options.isTakingOfficialReview ? false
    @isTakingTimeout = options.isTakingTimeout ? false
    @hasOfficialReview = options.hasOfficialReview ? true
    @timeouts = options.timeouts ? 3
    @jamSequence = seedrandom(@id, state: options.jamSequenceState ? true)
    @jams = options.jams ? [id: functions.uniqueId(8, @jamSequence)]
    @jamSequenceState = @jamSequence.state()
    @skaters = options.skaters ? []
    @penaltyBoxStates = options.penaltyBoxStates ? []
    @clockManager = new ClockManager()
    for boxState in @penaltyBoxStates
      boxState.clock = @clockManager.getOrAddClock(boxState.clock.alias, boxState.clock)
  save: (cascade=false) ->
    @jamSequenceState = @jamSequence.state()
    promise = super()
    if cascade
      jams = @jams.map (jam) -> jam.save(true)
      skaters = @skaters.map (skater) -> skater.save(true)
      promise = promise.then () ->
        Promise.join(skaters, jams)
      .return this
    promise
  load: () ->
    skaters = Skater.findByOrCreate(teamId: @id, @skaters).then (skaters) =>
      @skaters = skaters
    jams = Jam.findByOrCreate(teamId: @id, @jams)
    .then (jams) =>
      @jams = jams.sort (a, b) ->
        a.jamNumber > b.jamNumber
    Promise.join(skaters, jams).return(this)
  addSkater: (skater) ->
    skater.teamId = @id
    @skaters.push skater
  removeSkater: (skater) ->
    @skaters = (s for s in @skaters when s.id isnt skater.id)
    skater.destroy()
  getPoints: () ->
    @jams.reduce ((sum, jam) -> sum += jam.getPoints()), 0
  createNextJam: () ->
    lastJam = @jams[@jams.length - 1]
    jamId = functions.uniqueId(8, @jamSequence)
    args = id: jamId, jamNumber: @jams.length + 1, teamId: @id
    positionsInBox = lastJam.getPositionsInBox()
    if positionsInBox.length > 0
      args.lineupStatuses[0] = {}
      for position in positionsInBox
        args[position] = lastJam[position]
        args.lineupStatuses[0][position] = 'sat_in_box'
    Jam.findOrCreate(args).then (newJam) =>
      newJam.save(true)
      @jams.push newJam
  createJamsThrough: (jamNumber) ->
    for i in [@jams.length+1 .. jamNumber] by 1
      @createNextJam()
  toggleLeftEarly: (boxIndex) ->
    box = @penaltyBoxStates[boxIndex]
    if box?
      box.leftEarly = !box.leftEarly
      box.served = false
  toggleServed: (boxIndex) ->
    box = @penaltyBoxStates[boxIndex]
    if box?
      box.served = !box.served
      box.leftEarly = false
  addPenaltyTime: (boxIndex)->
    box = @penaltyBoxStates[boxIndex]
    if box?
      box.penaltyCount += 1
      box.clock.time += constants.PENALTY_DURATION_IN_MS
  togglePenaltyTimer: (boxIndex) ->
    box = @penaltyBoxStates[boxIndex]
    if box?
      if box.clock.isRunning then box.clock.stop() else box.clock.start()
  anyPenaltyTimerRunning: () ->
    @penaltyBoxStates.some (boxState) ->
      boxState.clock.isRunning
  toggleAllPenaltyTimers: () ->
    if @anyPenaltyTimerRunning()
      boxState.clock.stop() for boxState in @penaltyBoxStates
    else
      boxState.clock.start() for boxState in @penaltyBoxStates
  setPenaltyBoxSkater: (boxIndexOrPosition, clockId, skaterId) ->
    box = @getOrCreatePenaltyBoxState(boxIndexOrPosition, clockId)
    Skater.find(skaterId).then (skater) ->
      box.skater = skater
  newPenaltyBoxState: (position, clockId) ->
    position: position
    penaltyCount: 1
    clock: @clockManager.addClock(clockId ? functions.uniqueId(), PENALTY_CLOCK_SETTINGS)
  getOrCreatePenaltyBoxState: (boxIndexOrPosition, clockId) ->
    switch typeof boxIndexOrPosition
      when 'number'
        @penaltyBoxStates[boxIndexOrPosition]
      when 'string'
        box = @newPenaltyBoxState(boxIndexOrPosition, clockId)
        @penaltyBoxStates.push(box)
        box
  startTimeout: () ->
    @timeouts -= 1
    @isTakingTimeout = true
  removeOfficialReview: () ->
    @hasOfficialReview = false
    @officialReviewsRetained -= 1
  restoreOfficialReview: () ->
    @hasOfficialReview = true
    @officialReviewsRetained += 1
  renumberJams: () ->
    for jam, i in @jams
      jam.jamNumber = i + 1
      jam.save()
module.exports = Team
