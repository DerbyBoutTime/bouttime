exports = exports ? this
exports.classes = exports.classes ? {}
exports.classes.PenaltyBoxTrip = class PenaltyBoxTrip
  constructor: (state) ->
  update: (newState) ->
  serialize: () ->
    #penaltyId
    #satAt
    #warnedAt
    #releasedAt
    #timesAtJamEnd
    #timeServed
  addSkater: () ->
  addTime: () ->
  startTime: () ->
  stopTime: () ->
  startJam: () ->
  endJam: () ->
  addAlert: () ->

exports.classes.PenaltyBoxTimer = class PenaltyBoxTimer
  constructor: (state) ->
  update: (newState) ->
  serialize: () ->
  addTrip: () ->
  clearTrip: () ->