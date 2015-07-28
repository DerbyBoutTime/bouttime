functions = require '../functions'
_ = require 'underscore'
AppDispatcher = require '../dispatcher/app_dispatcher'
{ActionTypes} = require '../constants'
Store = require './store'
class Skater extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.SET_PENALTY
        @find(action.skaterId).then (skater) ->
          skater.setPenalty(action.jamNumber, action.penalty)
          skater.save()
      when ActionTypes.CLEAR_PENALTY
        @find(action.skaterId).then (skater) ->
          skater.clearPenalty(action.skaterPenaltyIndex)
          skater.save()
      when ActionTypes.UPDATE_PENALTY
        @find(action.skaterId).then (skater) ->
          skater.updatePenalty(action.skaterPenaltyIndex, action.opts)
          skater.save()
  constructor: (options={}) ->
    super options
    @teamId = options.teamId
    @name = options.name
    @number = options.number
    @penalties = options.penalties ? []
  setPenalty: (jamNumber, penalty) ->
    @penalties.push
      penalty: penalty
      jamNumber: jamNumber
      sat: false
  clearPenalty: (skaterPenaltyIndex) ->
    @penalties.splice(skaterPenaltyIndex, 1)
  updatePenalty: (skaterPenaltyIndex, opts={}) ->
    skaterPenalty = @penalties[skaterPenaltyIndex]
    _.extend(skaterPenalty, opts)
module.exports = Skater
