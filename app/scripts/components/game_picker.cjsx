React = require 'react/addons'
DemoData = require '../demo_data'
GameState = require '../models/game_state'
GameSetup = require './game_setup'
Game = require './game'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'GamePicker'
  getInitialState: () ->
    selectedGame: null
    games: GameState.all()
    newGame: new GameState()
  selectGame: (gameId) ->
    @setState(selectedGame: gameId)
  fillDemoGame: () ->
    @refs.gameSetup.reloadState()
    @setState newGame: DemoData.init()
  onChange: () ->
    @setState(games: GameState.all())
  openGame: () ->
    gameId = React.findDOMNode(@refs.gameSelect).value
    if gameId?
      @selectGame(gameId)
  componentDidMount: () ->
    GameState.addChangeListener @onChange
  componentWillUnmount: () ->
    GameState.removeChangeListener @onChange
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
              <option key={game.id} value={game.id}>{game.getDisplayName()}</option>
            , this}
          </select>
          <button className='btn fancy-btn' onClick={@openGame}>Open Game</button>
          <button className='btn fancy-btn' onClick={@fillDemoGame}>
            Fill Demo
          </button>
        </div>
        <GameSetup ref='gameSetup' gameState={@state.newGame} onSave={@selectGame.bind(this, @state.newGame.id)}/>
      </div>
      {if @state.selectedGame?
        <Game gameStateId={@state.selectedGame} backHandler={@selectGame.bind(this, null)}/>
      }
    </div>
