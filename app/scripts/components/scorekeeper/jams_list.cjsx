React = require 'react/addons'
$ = require 'jquery'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
functions = require '../../functions.coffee'
ItemRow = require '../shared/item_row'
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
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.CREATE_NEXT_JAM
      teamId: @props.team.id
      jamNumber: @props.team.jams.length + 1
  removeJam: (jamId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.REMOVE_JAM
      jamId: jamId
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
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-6">
          <div className="bt-box">
            <div className="row gutters-xs">
              <div className="col-xs-9">
                <strong>Current Jam</strong>
              </div>
              <div className="col-xs-3 text-right">
                <strong>{@props.jamNumber}</strong>
              </div>
            </div>
          </div>
        </div>
        <div className="col-xs-6">
          <div className="bt-box">
            <div className="row gutters-xs">
              <div className="col-xs-9">
                <strong>Game Total</strong>
              </div>
              <div className="col-xs-3 text-right">
                <strong>{@props.team.getPoints()}</strong>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className={jamsContainerClass}>
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
        <div className="row gutters-xs top-buffer">
          <div className="col-xs-2 text-center">
            <strong>Jam</strong>
          </div>
          <div className="col-xs-2 text-center">
            <strong>Skater</strong>
          </div>
          <div className="col-xs-2 col-xs-offset-2 text-center">
            <strong>Notes</strong>
          </div>
          <div className="col-xs-2 col-xs-offset-2 text-center">
            <strong>Points</strong>
          </div>
        </div>
        <div className="row gutters-xs top-buffer">
          <div className="col-xs-12">
            <button className="bt-btn btn-primary text-uppercase" onClick={@createNextJam}>Next Jam</button>
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