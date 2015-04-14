functions = require '../functions.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../constants.coffee'
Store = require './store.coffee'
Jam = require './jam.coffee'
Skater = require './skater.coffee'
class Pass extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.TOGGLE_INJURY
        pass = @find(action.passId)
        pass.toggleInjury()
        pass.save()
        @emitChange()
      when ActionTypes.TOGGLE_NOPASS
        pass = @find(action.passId)
        pass.toggleNopass()
        pass.save()
        @emitChange()
      when ActionTypes.TOGGLE_CALLOFF
        pass = @find(action.passId)
        pass.toggleCalloff()
        pass.save()
        @emitChange()
      when ActionTypes.TOGGLE_LOST_LEAD
        pass = @find(action.passId)
        pass.toggleLostLead()
        pass.save()
        @emitChange()
      when ActionTypes.TOGGLE_LEAD
        pass = @find(action.passId)
        pass.toggleLead()
        pass.save()
        @emitChange()
      when ActionTypes.SET_POINTS
        pass = @find(action.passId)
        pass.setPoints(action.points)
        pass.save()
        @emitChange()
      when ActionTypes.SET_PASS_JAMMER
        pass = @find(action.passId)
        pass.setJammer(action.skaterId)
        pass.save()
        @emitChange()
  @findByJamId: (jamId) ->
    (pass for id, pass of @store when pass.jamId is jamId and pass.type is 'Pass')
  constructor: (options={}) ->
    super options
    @jamId = options.jamId
    @passNumber = options.passNumber || 1
    @points = options.points || 0
    @jammerId = options.jammerId
    @injury = options.injury || false
    @lead = options.lead || false
    @lostLead = options.lostLead || false
    @calloff = options.calloff || false
    @nopass = options.nopass || false
  getJam: () =>
    @constructor.find(@jamId)
  toggleInjury: () ->
    @injury = not @injury
  toggleNopass: () ->
    @nopass = not @nopass
  toggleCalloff: () ->
    @calloff = not @calloff
  toggleLostLead: () ->
    @lostLead = not @lostLead
  toggleLead: () ->
    @lead = not @lead
  setPoints: (points) ->
    @points = points
  setJammer: (skaterId) ->
    @jammer = Skater.find(skaterId)
module.exports = Pass
