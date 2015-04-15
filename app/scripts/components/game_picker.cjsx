React = require 'react/addons'
DemoData = require '../demo_data'
GameState = require '../models/game_state'
Game = require './game'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'GamePicker'
  getInitialState: () ->
    selectedGame: null
    games: GameState.all()
  selectGame: (gameId) ->
    @setState(selectedGame: gameId)
  createDemoGame: () ->
    DemoData.init()
  onChange: () ->
    @setState(games: GameState.all())
  componentDidMount: () ->
    GameState.addChangeListener @onChange
  componentWillUnmount: () ->
    GameState.removeChangeListener @onChange
  render: () ->
    hideIfSelected = cx 
      'hidden': @state.selectedGame?
    <div className='game-picker'>
      <div className={hideIfSelected}>
        <ul>  
          {@state.games.map (game) ->
            <li key={game.id}><a onClick={@selectGame.bind(this, game.id)}>{game.id}</a></li>
          , this}
        </ul>
        <button className='btn' onClick={@createDemoGame}>
          Create Demo Game
        </button>
      </div>
      {if @state.selectedGame?
        <Game gameStateId={@state.selectedGame}/>
      }
    </div>
