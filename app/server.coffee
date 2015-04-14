express = require('express')
app = express();
http = require('http').Server(app);
io = require('socket.io')(http);
require('./scripts/dispatcher/app_dispatcher')

app.use '/', express.static(__dirname)

io.on 'connection', (socket) ->
  console.log('a user connected')
  socket.on 'disconnect', () ->
    console.log('user disconnected')
  socket.on 'app dispatcher', (action) ->
    console.log("Receive Action: #{action}")
    socket.broadcast.emit 'app dispatcher', action

http.listen 3000, () ->
  console.log('listening on *:3000')