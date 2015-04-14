Functions = require '../functions.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../constants.coffee'
Store = require './store.coffee'
Pass = require './pass.coffee'
Team = require './team.coffee'
Skater = require './skater.coffee'

class Jam extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.TOGGLE_NO_PIVOT
        jam = @find(action.jamId)
        jam.toggleNoPivot()
        jam.save()
        @emitChange()
      when ActionTypes.TOGGLE_STAR_PASS
        jam = @find(action.jamId)
        jam.toggleStarPass()
        jam.save()
        @emitChange()
      when ActionTypes.SET_SKATER_POSITION
        jam = @find(action.jamId)
        jam.setSkaterPosition(action.position, action.skaterId)
        jam.save()
        @emitChange()
      when ActionTypes.CYCLE_LINEUP_STATUS
        jam = @find(action.jamId)
        jam.cycleLineupStatus(action.statusIndex, action.position)
        jam.save()
        @emitChange()
      when ActionTypes.SET_POINTS
        AppDispatcher.waitFor([Pass.dispatchToken])
        pass = @find(action.passId)
        jam = pass.getJam()
        jam.createNextPass() if pass.id is jam.getLastPass().id
        pass.save()
        @emitChange()
      when ActionTypes.REORDER_PASS
        jam = @find(action.jamId)
        jam.reorderPass(action.sourcePassIndex, action.targetPassIndex)
        jam.save()
        @emitChange()
      when ActionTypes.SET_PASS_JAMMER
        AppDispatcher.waitFor([Pass.dispatchToken])
        pass = @find(action.passId)
        jam = pass.getJam()
        if not jam.jammer?
          jam.setSkaterPosition('jammer', action.skaterId)

  @findByTeamId: (teamId) ->
    (jam for id, jam of @store when jam.teamId is teamId and jam.type is 'Jam')

  constructor: (options={}) ->
    super options
    @teamId = options.teamId
    @jamNumber = options.jamNumber || 1
    @noPivot = options.noPivot || false
    @starPass = options.noPivot || false
    @pivotId = options.pivotId
    @blocker1Id = options.blocker1Id
    @blocker2Id = options.blocker2Id
    @blocker3Id = options.blocker3Id
    @jammerId = options.jammerId
    for pass in options.passes || [new Pass(jamId: @id)]
      pass.jamId = @id
      pass.save()
    @lineupStatuses = options.lineupStatuses || []

  save: () ->
    super()
    pass.save() for pass in @getPasses()

  getTeam: () ->
    @constructor.find(@teamId)

  getPasses: () ->
    Pass.findByJamId(@id).sort (a, b) ->
      a.passNumber - b.passNumber

  getLastPass: () ->
    passes = @getPasses()
    passes[passes.length - 1]

  getPositionsInBox: () ->
    positions = []
    for row in @lineupStatuses
      for position, status of row
        positions.push(position) if status in ['went_to_box', 'sat_in_box']
    positions

  getPoints: () ->
    @getPasses().reduce ((sum, pass) -> sum += pass.points), 0

  toggleNoPivot: () ->
    @noPivot = not @noPivot

  toggleStarPass: () ->
    @starPass = not @starPass

  setSkaterPosition: (position, skaterId) ->
    @[position] = Skater.find(skaterId)

  statusTransition: (status) ->
    switch status
      when 'clear' then 'went_to_box'
      when 'went_to_box' then 'went_to_box_and_released'
      when 'went_to_box_and_released' then 'sat_in_box'
      when 'sat_in_box' then 'sat_in_box_and_released'
      when 'sat_in_box_and_released' then 'injured'
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
    lastPass = @getLastPass()
    newPass = new Pass(passNumber: lastPass.passNumber + 1, jamId: @id)
    newPass.save()

  reorderPass: (sourcePassIndex, targetPassIndex) ->
    list = @getPasses()
    list.splice(targetPassIndex, 0, list.splice(sourcePassIndex, 1)[0])
    pass.passNumber = i + 1 for pass, i in list

module.exports = Jam