React = require 'react/addons'
DemoData = require '../demo_data'
AppDispatcher = require '../dispatcher/app_dispatcher'
GameState = require '../models/game_state'
GameMetadata = require '../models/game_metadata'
GameSetup = require './game_setup'
Game = require './game'
qs = require 'querystring'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'GamePicker'
  getInitialState: () ->
    selectedGame: @parseSelectedGame()
    games: []
    newGame: null
  parseSelectedGame: () ->
    qs.parse(window?.location?.hash?.substring(1)).id
  selectGame: (gameId) ->
    @setState(selectedGame: gameId)
  fillDemoGame: () ->
    @refs.gameSetup.reloadState()
    DemoData.init().then (game) =>
      @setState(newGame: game)
  onChange: () ->
    GameMetadata.all().then (games) =>
      @setState(games: games)
  openGame: () ->
    gameId = React.findDOMNode(@refs.gameSelect).value
    if gameId? and gameId.length > 0
      @selectGame(gameId)
  componentDidMount: () ->
    @onChange()
    GameMetadata.addChangeListener @onChange
    GameState.new().then (game) =>
      @setState(newGame: game)
  componentWillUnmount: () ->
    GameMetadata.removeChangeListener @onChange
  render: () ->
    hideIfSelected = cx
      'hidden': @state.selectedGame?
      'container': true
    <div className='game-picker'>
      <div className={hideIfSelected}>
        <h2>Game Select</h2>
        <div style={height: "100px"}>
          <select className="fancy-select" ref="gameSelect" style={height: "33px"}>
            {@state.games.map (game) ->
              <option key={game.id} value={game.id}>{game.display}</option>
            , this}
          </select>
          <button className='btn fancy-btn' onClick={@openGame}>Open Game</button>
          <button className='btn fancy-btn' onClick={@fillDemoGame}>
            Fill Demo
          </button>
        </div>
        {if @state.newGame? 
          <GameSetup ref='gameSetup' gameState={@state.newGame} onSave={@selectGame.bind(this, @state.newGame.id)}/>
        }
      </div>
      {if @state.selectedGame?
        <Game gameStateId={@state.selectedGame} backHandler={@selectGame.bind(this, null)}/>
      }

    </div>
