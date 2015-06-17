functions = require '../functions'
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
        jam = @find(action.jamId)
        jam.toggleNoPivot()
        jam.save()
        @emitChange()
        return jam
      when ActionTypes.TOGGLE_STAR_PASS
        jam = @find(action.jamId)
        jam.toggleStarPass()
        jam.save()
        @emitChange()
        return jam
      when ActionTypes.SET_STAR_PASS
        pass = Pass.find(action.passId)
        jam = Jam.find(pass.jamId)
        jam.setStarPass(pass)
        jam.save()
        @emitChange()
        return jam
      when ActionTypes.SET_SKATER_POSITION
        jam = @find(action.jamId)
        jam.setSkaterPosition(action.position, action.skaterId)
        jam.save()
        @emitChange()
        return jam
      when ActionTypes.CYCLE_LINEUP_STATUS
        jam = @find(action.jamId)
        jam.cycleLineupStatus(action.statusIndex, action.position)
        jam.save()
        @emitChange()
        return jam
      when ActionTypes.REORDER_PASS
        jam = @find(action.jamId)
        jam.reorderPass(action.sourcePassIndex, action.targetPassIndex)
        jam.save()
        @emitChange()
        return jam
      when ActionTypes.CREATE_NEXT_PASS
        jam = @find(action.jamId)
        jam.createPassesThrough(action.passNumber)
        jam.save()
        @emitChange()
        return jam
      when ActionTypes.SET_PASS_JAMMER
        AppDispatcher.waitFor([Pass.dispatchToken])
        pass = Pass.find(action.passId)
        jam = Jam.find(pass.jamId)
        if not jam.jammer?
          jam.setSkaterPosition('jammer', action.skaterId)
        jam.save()
        @emitChange()
        return jam
      when ActionTypes.REMOVE_PASS
        AppDispatcher.waitFor([Pass.dispatchToken])
        jam = Jam.find(action.jamId)
        jam.renumberPasses()
        jam.save()
        @emitChange()
        return jam
      when ActionTypes.REMOVE_JAM
        jam = Jam.find(action.jamId)
        jam.destroy()
        jam.save()
        @emitChange()
        return jam
  constructor: (options={}) ->
    super options
    @teamId = options.teamId
    @jamNumber = options.jamNumber ? 1
    @noPivot = options.noPivot ? false
    @starPass = options.starPass ? false
    @starPassNumber = options.starPassNumber ? 0
    @pivot = new Skater(options.pivot) if options.pivot
    @blocker1 = new Skater(options.blocker1) if options.blocker1
    @blocker2 = new Skater(options.blocker2) if options.blocker2
    @blocker3 = new Skater(options.blocker3) if options.blocker3
    @jammer = new Skater(options.jammer) if options.jammer
    @passSequence = seedrandom(@id, state: options.passSequenceState ? true)
    _passes = @getPasses()
    if _passes.length > 0
      @passes = _passes
    else if options.passes?
      @passes = (new Pass(pass) for pass in options.passes)
    else
      @passes = [new Pass(id: functions.uniqueId(8, @passSequence), jamId: @id)]
    @lineupStatuses = options.lineupStatuses ? []
    @passSequenceState = @passSequence.state()
  save: () ->
    @passSequenceState = @passSequence.state()
    super()
    pass.save() for pass in @passes
  getPasses: () ->
    Pass.findBy(jamId: @id).sort (a, b) ->
      a.passNumber - b.passNumber
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
  setStarPass: (pass) ->
    @starPass = not @starPass or @starPassNumber isnt pass.passNumber
    @starPassNumber = pass.passNumber
  setSkaterPosition: (position, skaterId) ->
    @[position] = Skater.find(skaterId)
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
    if Pass.find(passId)?
      return
    newPass = new Pass(id: passId, passNumber: @passes.length + 1, jamId: @id, jammer: lastPass.jammer)
    @passes.push newPass
  renumberPasses: () ->
    pass.passNumber = i + 1 for pass, i in @passes    
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
