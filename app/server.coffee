express = require('express')
app = express();
http = require('http').Server(app);
io = require('socket.io')(http);
GameState = require('./scripts/models/game_state')
require('./scripts/dispatcher/app_dispatcher')
{ActionTypes} = require './scripts/constants'
app.use '/', express.static(__dirname)
io.on 'connection', (socket) ->
  console.log('a user connected')
  socket.emit 'app dispatcher',
    type: ActionTypes.SYNC_GAMES
    games: GameState.all()
  socket.on 'disconnect', () ->
    console.log('user disconnected')
  socket.on 'app dispatcher', (action) ->
    console.log("Receive Action: #{action}")
    socket.broadcast.emit 'app dispatcher', action
http.listen 3000, () ->
  console.log('listening on *:3000')