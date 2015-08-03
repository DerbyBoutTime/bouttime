Promise = require 'bluebird'
seedrandom = require 'seedrandom'
functions = require '../functions'
AppDispatcher = require '../dispatcher/app_dispatcher'
{ActionTypes} = require '../constants'
Store = require './store'
Jam = require './jam'
Skater = require './skater'
BoxEntry = require './box_entry'
class Team extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.CREATE_NEXT_JAM
        @find(action.teamId).tap (team) ->
          team.createJamsThrough(action.jamNumber)
        .then (team) ->
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
      when ActionTypes.SET_PENALTY
        AppDispatcher.waitFor [Skater.dispatchToken]
        .spread (skater) =>
          @find(skater.teamId)
      when ActionTypes.CLEAR_PENALTY
        AppDispatcher.waitFor [Skater.dispatchToken]
        .spread (skater) =>
          @find(skater.teamId)
      when ActionTypes.UPDATE_PENALTY
        AppDispatcher.waitFor [Skater.dispatchToken]
        .spread (skater) =>
          @find(skater.teamId)
      when ActionTypes.TOGGLE_LEAD
        AppDispatcher.waitFor [Jam.dispatchToken]
        .spread (jam) =>
          @find jam.teamId
      when ActionTypes.TOGGLE_LOST_LEAD
        AppDispatcher.waitFor [Jam.dispatchToken]
        .spread (jam) =>
          @find jam.teamId
      when ActionTypes.TOGGLE_CALLOFF
        AppDispatcher.waitFor [Jam.dispatchToken]
        .spread (jam) =>
          @find jam.teamId
      when ActionTypes.SET_POINTS
        AppDispatcher.waitFor [Jam.dispatchToken]
        .spread (jam) =>
          @find jam.teamId
      when ActionTypes.TOGGLE_PENALTY_SERVED
        AppDispatcher.waitFor [BoxEntry.dispatchToken]
        .spread (box) =>
          @find box.teamId
          .tap (team) ->
            team.createBox(box.position, box.sort)
          .tap @save
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
    @jams = (options.jams ? [id: functions.uniqueId(8, @jamSequence)]).map (jam) -> new Jam(jam)
    @jamSequenceState = @jamSequence.state()
    @seatSequence = seedrandom(@id, state: options.seatSequenceState ? true)
    @seats = (options.seats ? [
      {id: functions.uniqueId(8, @seatSequence), position: 'jammer', sort: 0},
      {id: functions.uniqueId(8, @seatSequence), position: 'blocker', sort: 1},
      {id: functions.uniqueId(8, @seatSequence), position: 'blocker', sort: 2},
      {id: functions.uniqueId(8, @seatSequence), position: 'blocker', sort: 3}
    ])
    @seats = @seats.map (seat) -> new BoxEntry(seat)
    @seatSequenceState = @seatSequence.state()
    @skaters = (options.skaters ? []).map (skater) -> new Skater(skater)
  save: (cascade=false) ->
    @jamSequenceState = @jamSequence.state()
    @seatSequenceState = @seatSequence.state()
    promise = super()
    if cascade
      jams = @jams.map (jam) -> jam.save(true)
      skaters = @skaters.map (skater) -> skater.save(true)
      seats = @seats.map (seat) -> seat.save(true)
      promise = promise.then () ->
        Promise.join(skaters, jams, seats)
      .return this
    promise
  load: () ->
    skaters = Skater.findByOrCreate(teamId: @id, @skaters).then (skaters) =>
      @skaters = skaters
    jams = Jam.findByOrCreate(teamId: @id, @jams)
    .then (jams) =>
      @jams = jams.sort (a, b) ->
        a.jamNumber > b.jamNumber
    seats = BoxEntry.findByOrCreate(teamId: @id, served: false, @seats)
    .then (seats) =>
      @seats = seats.sort (a, b) ->
        a.sort > b.sort
    Promise.join(skaters, jams, seats).return(this)
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
      @jams.push newJam
      newJam.save(true)
  createJamsThrough: (jamNumber) ->
    jamNumbers = (i for i in [@jams.length+1 .. jamNumber] by 1)
    Promise.each (jamNumbers), @createNextJam.bind(this)
    .return this
  anyPenaltyTimerRunning: () ->
    @seats.some (seat) ->
      seat.penaltyTimerIsRunning()
  toggleAllPenaltyTimers: () ->
    if @anyPenaltyTimerRunning()
      seat.stopPenaltyTimer() for seat in @seats when seat.dirty
    else
      seat.startPenaltyTimer() for seat in @seats when seat.dirty
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
  isTakingTimeoutOrOfficialReview: () ->
    @isTakingTimeout or @isTakingOfficialReview
  createBox: (position, sort) ->
    newBox = new BoxEntry(id: functions.uniqueId(8, @seatSequence), teamId: @id, position: position, sort: sort)
    newBox.save()
module.exports = Team
