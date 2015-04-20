express = require('express')
app = express();
http = require('http').Server(app);
io = require('socket.io')(http);
constants = require('./scripts/constants')
GameState = require('./scripts/models/game_state')
require('./scripts/dispatcher/app_dispatcher')
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
    console.log("Receive Action: #{action}")
    socket.broadcast.emit 'app dispatcher', action
  socket.on 'sync clocks', () ->
    console.log "syncing clocks 1"
    timeX = new Date().getTime()
    setTimeout( ()->
      console.log "syncing clocks 2"
      timeY = new Date().getTime()
      socket.emit 'clocks synced',
        timeX: timeX
        timeY: timeY
    ,constants.CLOCK_SYNC_DELAY_DURATION_IN_MS)
http.listen 3000, () ->
  console.log('listening on *:3000')