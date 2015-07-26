functions = require '../functions'
Promise = require 'bluebird'
seedrandom = require 'seedrandom'
AppDispatcher = require '../dispatcher/app_dispatcher'
{ActionTypes} = require '../constants'
Store = require './store'
Pass = require './pass'
Skater = require './skater'
class Jam extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.TOGGLE_NO_PIVOT
        @find(action.jamId).then (jam) =>
          jam.toggleNoPivot()
          jam.save()
      when ActionTypes.TOGGLE_STAR_PASS
        @find(action.jamId).then (jam) =>
          jam.toggleStarPass()
          jam.save()
      when ActionTypes.SET_STAR_PASS
          Pass.find(action.passId).then (pass) ->
            [Jam.find(pass.jamId), pass.passNumber]
          .spread (jam, passNumber) ->
            jam.setStarPass(passNumber)
            jam.save()
      when ActionTypes.SET_SKATER_POSITION
        @find(action.jamId).tap (jam) =>
          jam.setSkaterPosition(action.position, action.skaterId)
        .then (jam) ->
          jam.save()
      when ActionTypes.CYCLE_LINEUP_STATUS
        @find(action.jamId).then (jam) =>
          jam.cycleLineupStatus(action.statusIndex, action.position)
          jam.save()
      when ActionTypes.REORDER_PASS
        @find(action.jamId).then (jam) =>
          jam.reorderPass(action.sourcePassIndex, action.targetPassIndex)
          jam.save()
      when ActionTypes.CREATE_NEXT_PASS
        @find(action.jamId).then (jam) =>
          jam.createPassesThrough(action.passNumber)
          jam.save()
      when ActionTypes.SET_PASS_JAMMER
        AppDispatcher.waitFor([Pass.dispatchToken])
        Pass.find(action.passId).then (pass) =>
          Jam.find(pass.jamId)
        .then (jam) =>
          if not jam.jammer?
            jam.setSkaterPosition('jammer', action.skaterId)
          jam.save()
      when ActionTypes.REMOVE_PASS
        AppDispatcher.waitFor([Pass.dispatchToken])
        .spread (pass) =>
          @find(pass.jamId)
        .then (jam) ->
          jam.renumberPasses()
          jam.save()
      when ActionTypes.REMOVE_JAM
        @find(action.jamId).then (jam) =>
          jam.destroy()
  constructor: (options={}) ->
    super options
    @teamId = options.teamId
    @jamNumber = options.jamNumber ? 1
    @noPivot = options.noPivot ? false
    @starPass = options.starPass ? false
    @starPassNumber = options.starPassNumber ? 0
    @pivot = options.pivot
    @blocker1 = options.blocker1
    @blocker2 = options.blocker2
    @blocker3 = options.blocker3
    @jammer = options.jammer
    @passSequence = seedrandom(@id, state: options.passSequenceState ? true)
    @passes = options.passes ? [id: functions.uniqueId(8, @passSequence)]
    @passSequenceState = @passSequence.state()
    @lineupStatuses = options.lineupStatuses ? []
  load: () ->
    lineup = ['jammer', 'pivot', 'blocker1', 'blocker2', 'blocker3'].map (position) =>
      if @[position]
        Skater.new(@[position]).then (skater) =>
          @[position] = skater
      else
        null
    lineup = Promise.all(lineup)
    passes = Pass.findByOrCreate jamId: @id, @passes
    .then (passes) =>
      @passes = passes.sort (a, b) ->
        a.passNumber > b.passNumber
    Promise.join(lineup, passes).return(this)
  save: (cascade=false, emit=true) ->
    @passSequenceState = @passSequence.state()
    promise = super()
    if cascade
      promise = promise.get('passes').map (pass) ->
        pass.save(true, false)
      .return this
    promise
  getPositionsInBox: () ->
    positions = []
    for row in @lineupStatuses
      for position, status of row
        positions.push(position) if status in ['went_to_box', 'sat_in_box']
    positions
  getPoints: () ->
    @passes.reduce ((sum, pass) -> sum += pass.points), 0
  getNotes: () ->
    flags = @passes.reduce (prev, pass) ->
      injury: prev.injury or pass.injury
      nopass: prev.nopass or pass.nopass
      calloff: prev.calloff or pass.calloff
      lost: prev.lost  or pass.lostLead
      lead: prev.lead or pass.lead
    , {}
    Object.keys(flags).filter (key) ->
      flags[key]
  toggleNoPivot: () ->
    @noPivot = not @noPivot
  toggleStarPass: () ->
    @starPass = not @starPass
  setStarPass: (passNumber) ->
    @starPass = not @starPass or @starPassNumber isnt passNumber
    @starPassNumber = passNumber
  setSkaterPosition: (position, skaterId) ->
    Skater.find(skaterId).then (skater) =>
      if @[position]?.id is skater.id
        @[position] = null
      else
        @[position] = skater
  statusTransition: (status) ->
    switch status
      when 'clear' then 'went_to_box'
      when 'went_to_box' then 'went_to_box_and_released'
      when 'went_to_box_and_released' then 'sat_in_box'
      when 'sat_in_box' then 'sat_in_box_and_released'
      when 'sat_in_box_and_released' then 'continuing_penalty'
      when 'continuing_penalty' then 'continuing_penalty_and_released'
      when 'continuing_penalty_and_released' then 'injured'
      when 'injured' then 'clear'
      else 'clear'
  cycleLineupStatus: (statusIndex, position) ->
    # Make a new row if need be
    if statusIndex >= @lineupStatuses.length
      @lineupStatuses[statusIndex] = {pivot: 'clear', blocker1: 'clear', blocker2: 'clear', blocker3: 'clear', jammer: 'clear', order: statusIndex }
    # Initialize position to clear
    if not @lineupStatuses[statusIndex][position]
      @lineupStatuses[statusIndex][position] = 'clear'
    currentStatus = @lineupStatuses[statusIndex][position]
    @lineupStatuses[statusIndex][position] = @statusTransition(currentStatus)
  createNextPass: () ->
    lastPass = @passes[@passes.length - 1]
    passId = functions.uniqueId(8, @passSequence)
    Pass.findOrCreate(id: passId, passNumber: @passes.length + 1, jamId: @id, jammer: lastPass.jammer)
    .then (newPass) =>
      @passes.push newPass
      newPass.save(true)
  renumberPasses: () ->
    for pass, i in @passes
      pass.passNumber = i + 1
      pass.save()
  createPassesThrough: (passNumber) ->
    for i in [@passes.length+1 .. passNumber] by 1
      @createNextPass()
  reorderPass: (sourcePassIndex, targetPassIndex) ->
    @passes.splice(targetPassIndex, 0, @passes.splice(sourcePassIndex, 1)[0])
    @renumberPasses()
  isInjured: (position) ->
    @lineupStatuses? and @lineupStatuses.some (status) ->
      status[position] is 'injured'
  getLineup: () ->
    [@pivot, @blocker1, @blocker2, @blocker3, @jammer].filter (position) ->
      position?
  inLineup: (skater) ->
    skater.number in @getLineup().map (s) -> s.number
module.exports = Jam
