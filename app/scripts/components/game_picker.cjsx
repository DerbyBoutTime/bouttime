React = require 'react/addons'
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
  handleImport: (evt) ->
    file = evt.target.files[0]
    reader = new FileReader()
    reader.onload = (fEvt) =>
      args = JSON.parse(fEvt.target.result)
      @importGame(args)
    reader.readAsText file
  importGame: (game) ->
    @refs.gameSetup.reloadState()
    GameState.new(game)
    .then (gs) =>
      @setState(newGame: gs)
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
        <div className='row gutters-xs'>
          <div className='col-xs-12 col-sm-6'>
            <div className='bt-select top-buffer'>
              <select ref="gameSelect">
                {@state.games.map (game) ->
                  <option key={game.id} value={game.id}>{game.display}</option>
                , this}
              </select>
            </div>
          </div>
          <div className='col-xs-12 col-sm-6'>
            <button className='bt-btn top-buffer' onClick={@openGame}>Open Game</button>
          </div>
        </div>
        <h2>Game Import</h2>
        <input type='file' accept="application/json" onChange={@handleImport}/>
        {if @state.newGame? 
          <GameSetup ref='gameSetup' gameState={@state.newGame} onSave={@selectGame.bind(this, @state.newGame.id)}/>
        }
      </div>
      {if @state.selectedGame?
        <Game gameStateId={@state.selectedGame} backHandler={@selectGame.bind(this, null)}/>
      }

    </div>
