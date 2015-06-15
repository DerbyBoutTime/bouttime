React = require 'react/addons'
$ = require 'jquery'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
functions = require '../../functions.coffee'
ItemRow = require './item_row'
JamItem = require './jam_item'
JamDetails = require './jam_details'
Jam = require '../../models/jam.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamsList'
  propTypes:
    team: React.PropTypes.object.isRequired
    setSelectorContext: React.PropTypes.func.isRequired
  selectedJam: () ->
    @props.team.jams[@state.jamSelected ? 0]
  handleMainMenu: () ->
    @setState(jamSelected: null)
  handleJamSelection: (jamIndex) ->
    @setState(jamSelected: jamIndex)
  handleNextJam: () ->
    if @state.jamSelected < @props.team.jams.length - 1
      $('.scorekeeper .collapse.in').collapse('hide')
      @setState(jamSelected: @state.jamSelected + 1)
  handlePreviousJam: () ->
    if @state.jamSelected > 0
      $('.scorekeeper .collapse.in').collapse('hide')
      @setState(jamSelected: @state.jamSelected - 1)
  createNextJam: () ->
    AppDispatcher.dispatch
      type: ActionTypes.CREATE_NEXT_JAM
      teamId: @props.team.id
  removeJam: (jamId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.REMOVE_JAM
      jamId: jamId
      teamId: @props.team.id
  getInitialState: () ->
    jamSelected: null
  render: () ->
    jamsContainerClass = cx
      'jams fade-hide': true
      'in': !@state.jamSelected?
    passesContainerClass = cx
      'passes-container fade-hide': true
      'in': @state.jamSelected?
    <div className="jams-list">
      <div className="row stats gutters-xs">
        <div className="col-xs-6">
          <div className="stat current-jam">
            <div className="row gutters-xs">
              <div className="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                <strong>Current Jam</strong>
              </div>
              <div className="col-xs-2 text-right current-jam-score">
                <strong>{@props.jamNumber}</strong>
              </div>
            </div>
          </div>
        </div>
        <div className="col-xs-6">
          <div className="stat game-total">
            <div className="row gutters-xs">
              <div className="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                <strong>Game Total</strong>
              </div>
              <div className="col-xs-2 text-right game-total-score">
                <strong>{@props.team.getPoints()}</strong>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className={jamsContainerClass}>
        <div className="headers">
          <div className="row gutters-xs">
            <div className="col-xs-2">
              <strong>Jam</strong>
            </div>
            <div className="col-xs-2">
              <strong>Skater</strong>
            </div>
            <div className="col-xs-2 col-xs-offset-1 text-center">
              <strong>Notes</strong>
            </div>
            <div className="col-xs-2 col-xs-offset-1 text-center">
              <strong>Points</strong>
            </div>
          </div>
        </div>
        <div className="columns">
          {@props.team.jams.map (jam, jamIndex) ->
            item = <JamItem
              jam={jam}
              setSelectorContext={@props.setSelectorContext.bind(this, jam)}
              style={@props.team.colorBarStyle}
              selectionHandler={@handleJamSelection.bind(this, jamIndex)} />
            <ItemRow
              key={jam.id}
              item={item}
              removeHandler={@removeJam.bind(this, jam.id)}/>
          , this}
        </div>
        <div className="actions">
          <div className="row gutters-xs">
            <div className="col-sm-12 col-xs-12">
              <button className="bt-btn action" onClick={@createNextJam}>Next Jam</button>
            </div>
          </div>
        </div>
      </div>
      <div className={passesContainerClass}>
        <JamDetails
          jam={@selectedJam()}
          setSelectorContext={@props.setSelectorContext.bind(null, @selectedJam())}
          mainMenuHandler={@handleMainMenu}
          prevJamHandler={@handlePreviousJam}
          nextJamHandler={@handleNextJam} />
      </div>
    </div>