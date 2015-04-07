exports = exports ? this
exports.classes = exports.classes ? {}
exports.classes.Aggregations = class Aggregations
  constructor: (state) ->
  update: (newState) ->
  serialize: () ->

  #lineup tracker
  currentInjuries: () ->
  currentLineup: () ->
  currentJammer: () ->
  skaterIsInLineup: () ->

  #scorekeeper
  currentJamPoints: () ->
  totalPoints: (jamNumber) ->
  totalCalloffs: () ->
  totalLead: () ->
  totalLostLead: () ->
  totalInjury: () ->
  totalNoPass: () ->
  estimatedLapPoints: () ->
  jamNotes: (jamNumber) ->
  jamPoints: (jamNumber) ->
  jamJammer: (jamNumber) ->
  scoreByJam: () ->

  #penalty tracker
  penaltyAlertBySkater: () ->
  penaltyListBySkater: () ->
  totalJammerPenalties: () ->
  totalPenalties: () ->
  totalJammerPenalties: () ->
  totalBlockerPenalties: () ->

  #penalty box timer
  currentBoxTimings: () ->
  penaltyQueue: () ->
  isPowerJam: () ->
  timeServedBySkater: () ->
  totalTimeServed: () ->
  totalPowerJamTime: () ->
  totalBlockerTime: () ->
  totalPowerStarts: () ->