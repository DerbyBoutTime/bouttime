React = require 'react/addons'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
JamItem = require './jam_item.cjsx'
JamDetails = require './jam_details.cjsx'
Jam = require '../../models/jam.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamsList'
  propTypes:
    team: React.PropTypes.object.isRequired
    setSelectorContext: React.PropTypes.func.isRequired
  selectedJam: () ->
    @props.team.getJams()[@state.jamSelected || 0]
  handleMainMenu: () ->
    @setState(jamSelected: null)
  handleJamSelection: (jamIndex, newJam) ->
    if newJam
      AppDispatcher.dispatchAndEmit
        type: ActionTypes.CREATE_NEXT_JAM
        teamId: @props.team.id
    @setState(jamSelected: jamIndex)
  handleNextJam: () ->
    if @state.jamSelected < @props.team.getJams().length - 1
      $('.scorekeeper .collapse.in').collapse('hide')
      @setState(jamSelected: @state.jamSelected + 1)
  handlePreviousJam: () ->
    if @state.jamSelected > 0
      $('.scorekeeper .collapse.in').collapse('hide')
      @setState(jamSelected: @state.jamSelected - 1)
  getInitialState: () ->
    jamSelected: null
  render: () ->
    JamItemFactory = React.createFactory(JamItem)
    # jam's schema is same as jam_state table
    jamComponents = @props.team.getJams().map (jam, jamIndex) =>
      JamItemFactory
        key: jamIndex
        jam: jam
        setSelectorContext: @props.setSelectorContext.bind(this, jam)
        style: @props.team.colorBarStyle
        selectionHandler: @handleJamSelection.bind(this, jamIndex, false)
    # add a blank jam for adding a next jam
    emptyJam = new Jam(jamNumber: @props.team.getJams().length+1, teamId: @props.team.id)
    jamComponents.push(
      JamItemFactory
        key: @props.team.getJams().length
        jam: emptyJam
        setSelectorContext: @props.setSelectorContext.bind(this, emptyJam)
        style: @props.team.colorBarStyle
        selectionHandler: @handleJamSelection.bind(this, @props.team.getJams().length, true)
    )
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
          {jamComponents}
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