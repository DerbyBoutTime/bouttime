functions = require '../functions.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
CountdownClock = require '../clock.coffee'
Team = require './team.coffee'
class GameState
  @gameStates: {}

  @find: (id) ->
    @gameStates[id]

  constructor: (options={}) ->
    @id = functions.uniqueId()
    @state = options.state || 'pregame'
    @jamNumber = options.jamNumber || 0
    @periodNumber = options.periodNumber || 0
    @jamClock = options.jamClock || new CountdownClock()
    @periodClock = options.periodClock || new CountdownClock()
    @home = options.home || new Team()
    @away = options.away || new Team()
    @penalties = [
      {name: "High Block"
      code: "A"}
      ,
      {name: "Insubordination"
      code: "N"}
      ,
      {name: "Back Block"
      code: "B"}
      ,
      {name: "Skating Out of Bnds."
      code: "S"}
      ,
      {name: "Elbows"
      code: "E"}
      ,
      {name: "Cutting the Track"
      code: "X"}
      ,
      {name: "Forearms"
      code: "F"}
      ,
      {name: "Delay of Game"
      code: "Z"}
      ,
      {name: "Misconduct"
      code: "G"}
      ,
      {name: "Dir. of Game Play"
      code: "C"}
      ,
      {name: "Blocking with Head"
      code: "H"}
      ,
      {name: "Out of Bounds"
      code: "O"}
      ,
      {name: "Low Block"
      code: "L"}
      ,
      {name: "Out of Play"
      code: "P"}
      ,
      {name: "Multi-Player Block"
      code: "M"}
      ,
      {name: "Illegal Procedure"
      code: "I"}
      ,
      {name: "Gross Misconduct"
      code: "G"}
    ]

  save: () ->
    gameStates[@id] = this

module.exports = GameState
