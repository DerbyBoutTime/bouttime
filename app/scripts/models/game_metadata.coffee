AppDispatcher = require '../dispatcher/app_dispatcher'
{ActionTypes} = require '../constants'
Store = require './store'
class GameMetadata extends Store
  @dispatchToken: AppDispatcher.register (action) =>
    switch action.type
      when ActionTypes.SYNC_GAMES
        new GameMetadata(obj).save() for obj in action.games
        @emitChange()
  constructor: (options={}) ->
    super options
    @display = options.display ? 'Untitled Game'
module.exports = GameMetadata


