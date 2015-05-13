unless localStorage?
  {LocalStorage} = require('node-localstorage')
  GLOBAL.localStorage = new LocalStorage('./scratch')
config = require('./scripts/config')
module.exports = start: (port=3000) ->
  config.set('socketUrl', "localhost:#{port}")
  express = require('express')
  app = express();
  http = require('http').Server(app);
  io = require('socket.io')(http);
  constants = require('./scripts/constants')
  Store = require('./scripts/models/store')
  MemoryStorage = require('./scripts/memory_storage')
  Store.store = new MemoryStorage()
  GameState = require('./scripts/models/game_state')
  AppDispatcher = require('./scripts/dispatcher/app_dispatcher')
  {ActionTypes} = require './scripts/constants'
  app.use '/', express.static(__dirname)
  io.on 'connection', (socket) ->
    console.log('a user connected')
    socket.emit 'connected'
    socket.emit 'app dispatcher',
      type: ActionTypes.SYNC_GAMES
      games: GameState.all()
    socket.on 'disconnect', () ->
      console.log('user disconnected')
    socket.on 'app dispatcher', (action) ->
      AppDispatcher.dispatch(action)
      socket.broadcast.emit 'app dispatcher', action
    socket.on 'sync clocks', () ->
      timeX = new Date().getTime()
      setTimeout( ()->
        timeY = new Date().getTime()
        socket.emit 'clocks synced',
          timeX: timeX
          timeY: timeY
      ,constants.CLOCK_SYNC_DELAY_DURATION_IN_MS)
  http.listen port, () ->
    console.log("listening on *:#{port}")
