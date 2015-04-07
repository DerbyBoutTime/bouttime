exports = exports ? this
exports.classes = exports.classes ? {}
exports.classes.LineupTracker = class LineupTracker
  constructor: (state) ->
    @lineups = {}
  update: (newState) ->
  serialize: () ->
  setSkater: (jamNumber, index, skaterNumber) ->
  unSetSkater: (jamNumber, index) ->
  setPivot: (jamNumber, thereIsAPivot) ->
  setStarPass: (jamNumber) ->
  unSetStarPass: (jamNumber) ->
  skaterEnterBox: (jamNumber) ->
  skaterExitBox: (jamNumber) ->
  skaterStartInBox: (jamNumber) ->
  skaterStartInAndExitedBox: (jamNumber) ->
  skaterInjured: (jamNumber, skaterNumber) ->