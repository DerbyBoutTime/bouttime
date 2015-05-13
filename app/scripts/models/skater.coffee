functions = require '../functions'
AppDispatcher = require '../dispatcher/app_dispatcher'
{ActionTypes} = require '../constants'
Store = require './store'
class Skater extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.SET_PENALTY
        skater = @find(action.skaterId)
        skater.setPenalty(action.jamNumber, action.penalty)
        skater.save()
        @emitChange()
      when ActionTypes.CLEAR_PENALTY
        skater = @find(action.skaterId)
        skater.clearPenalty(action.skaterPenaltyIndex)
        skater.save()
        @emitChange()
      when ActionTypes.UPDATE_PENALTY
        skater = @find(action.skaterId)
        skater.updatePenalty(action.skaterPenaltyIndex, action.opts)
        skater.save()
        @emitChange()
  constructor: (options={}) ->
    super options
    @teamId = options.teamId
    @name = options.name
    @number = options.number
    @penalties = options.penalties || []
  setPenalty: (jamNumber, penalty) ->
    @penalties.push
      penalty: penalty
      jamNumber: jamNumber
  clearPenalty: (skaterPenaltyIndex) ->
    @penalties.splice(skaterPenaltyIndex, 1)
  updatePenalty: (skaterPenaltyIndex, opts={}) ->
    skaterPenalty = @penalties[skaterPenaltyIndex]
    $.extend(skaterPenalty, opts)
module.exports = Skater
