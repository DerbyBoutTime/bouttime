functions = require '../functions'
AppDispatcher = require '../dispatcher/app_dispatcher'
{ActionTypes} = require '../constants'
Store = require './store'
Skater = require './skater'
class Pass extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.TOGGLE_INJURY
        pass = @find(action.passId)
        pass.toggleInjury()
        pass.save()
        @emitChange()
        return pass
      when ActionTypes.TOGGLE_NOPASS
        pass = @find(action.passId)
        pass.toggleNopass()
        pass.save()
        @emitChange()
        return pass
      when ActionTypes.TOGGLE_CALLOFF
        pass = @find(action.passId)
        pass.toggleCalloff()
        pass.save()
        @emitChange()
        return pass
      when ActionTypes.TOGGLE_LOST_LEAD
        pass = @find(action.passId)
        pass.toggleLostLead()
        pass.save()
        @emitChange()
        return pass
      when ActionTypes.TOGGLE_LEAD
        pass = @find(action.passId)
        pass.toggleLead()
        pass.save()
        @emitChange()
        return pass
      when ActionTypes.SET_STAR_PASS
        pass = @find(action.passId)
        pass.setPoints(0)
        pass.save()
        @emitChange()
        return pass
      when ActionTypes.SET_POINTS
        pass = @find(action.passId)
        pass.setPoints(action.points)
        pass.save()
        @emitChange()
        return pass
      when ActionTypes.SET_PASS_JAMMER
        pass = @find(action.passId)
        pass.setJammer(action.skaterId)
        pass.save()
        @emitChange()
        return pass
  constructor: (options={}) ->
    super options
    @jamId = options.jamId
    @passNumber = options.passNumber ? 1
    @points = options.points ? 0
    @jammerId = options.jammerId
    @injury = options.injury ? false
    @lead = options.lead ? false
    @lostLead = options.lostLead ? false
    @calloff = options.calloff ? false
    @nopass = options.nopass ? false
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
  getNotes: () ->
    flags =
      injury: @injury
      nopass: @nopass
      calloff: @calloff
      lost: @lostLead
      lead: @lead
    Object.keys(flags).filter (key) ->
      flags[key]
module.exports = Pass
