React = require 'react/addons'
JamItem = require './jam_item.cjsx'
JamDetails = require './jam_details.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamsList'
  propTypes:
    team: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired
  bindActions: (jamIndex) ->
    Object.keys(@props.actions).map((key) ->
      key: key
      value: @props.actions[key].bind(this, jamIndex)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
  getTeamPoints: ()->
    team = @props.team
    points = 0
    team.jams.map (jam) =>
      jam.passes.map (pass) =>
        points += pass.points || 0
    return points
  selectedJam: () ->
    @props.team.jams[@state.jamSelected || 0]
  handleMainMenu: () ->
    @setState(jamSelected: null)
  handleJamSelection: (jamIndex, newJam) ->
    if newJam
      @props.actions.newJam(jamNumber: @props.team.jams.length + 1, passes: [passNumber: 1, sort: 0])
    @setState(jamSelected: jamIndex)
  handleNextJam: () ->
    if @state.jamSelected < @props.team.jams.length - 1
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
    jamComponents = @props.team.jams.map (jam, jamIndex) =>
      JamItemFactory
        key: jamIndex
        jam: jam
        actions: @bindActions(jamIndex)
        style: @props.team.colorBarStyle
        selectionHandler: @handleJamSelection.bind(this, jamIndex, false)
    # add a blank jam for adding a next jam
    jamComponents.push(
      JamItemFactory
        key: @props.team.jams.length
        jam: {jamNumber: @props.team.jams.length+1, passes: []}
        actions: @bindActions(@props.team.jams.length)
        style: @props.team.colorBarStyle
        selectionHandler: @handleJamSelection.bind(this, @props.team.jams.length, true)
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
                <strong>{@getTeamPoints('away')}</strong>
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
          actions={@bindActions(@state.jamSelected)}
          mainMenuHandler={@handleMainMenu}
          prevJamHandler={@handlePreviousJam}
          nextJamHandler={@handleNextJam} />
      </div>
    </div>