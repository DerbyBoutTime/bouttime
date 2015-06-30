Promise = require 'bluebird'
functions = require '../functions'
AppDispatcher = require '../dispatcher/app_dispatcher'
{ActionTypes} = require '../constants'
Store = require './store'
Skater = require './skater'
class Pass extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.TOGGLE_INJURY
        @find(action.passId).then (pass) =>
          pass.toggleInjury()
          pass.save()
      when ActionTypes.TOGGLE_NOPASS
        @find(action.passId).then (pass) =>
          pass.toggleNopass()
          pass.save()
      when ActionTypes.TOGGLE_CALLOFF
        @find(action.passId).then (pass) =>
          pass.toggleCalloff()
          pass.save()
      when ActionTypes.TOGGLE_LOST_LEAD
        @find(action.passId).then (pass) =>
          pass.toggleLostLead()
          pass.save()
      when ActionTypes.TOGGLE_LEAD
        @find(action.passId).then (pass) =>
          pass.toggleLead()
          pass.save()
      when ActionTypes.SET_STAR_PASS
        @find(action.passId).then (pass) =>
          pass.setPoints(0)
          pass.save()
      when ActionTypes.SET_POINTS
        @find(action.passId).then (pass) =>
          pass.setPoints(action.points)
          pass.save()
      when ActionTypes.SET_PASS_JAMMER
        @find(action.passId).then (pass) =>
          pass.setJammer(action.skaterId)
          pass.save()
      when ActionTypes.REMOVE_PASS
        @find(action.passId).then (pass) =>
          pass.destroy()
  constructor: (options={}) ->
    super options
    @jamId = options.jamId
    @passNumber = options.passNumber ? 1
    @points = options.points ? 0
    @jammer = new Skater(options.jammer) if options.jammer
    @injury = options.injury ? false
    @lead = options.lead ? false
    @lostLead = options.lostLead ? false
    @calloff = options.calloff ? false
    @nopass = options.nopass ? false
  load: () ->
    if @jammer
      Skater.new(@jammer).then (jammer) =>
        @jammer = jammer
      .return(this)
    else
      Promise.resolve(this)
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
    Skater.find(skaterId).then (skater) ->
      @jammer = skater
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
