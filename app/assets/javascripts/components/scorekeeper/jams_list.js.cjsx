cx = React.addons.classSet
exports = exports ? this
exports.JamsList = React.createClass
  displayName: 'JamsList'
  propTypes:
    teamState: React.PropTypes.object.isRequired
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
    team = @props.teamState
    points = 0
    team.jamStates.map (jam) =>
      jam.passStates.map (pass) =>
        points += pass.points || 0
    return points
  selectedJam: () ->
    @props.teamState.jamStates[@state.jamSelected || 0]
  handleMainMenu: () ->
    @setState(jamSelected: null)
  handleJamSelection: (jamIndex, newJam) ->
    if newJam
      @props.actions.newJam(jamNumber: @props.teamState.jamStates.length + 1, passStates: [passNumber: 1, sort: 0])
    @setState(jamSelected: jamIndex)
  handleNextJam: () ->
    if @state.jamSelected < @props.teamState.jamStates.length - 1
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
    jamComponents = @props.teamState.jamStates.map (jamState, jamIndex) =>
      JamItemFactory
        key: jamIndex
        jamState: jamState
        actions: @bindActions(jamIndex)
        style: @props.teamState.colorBarStyle
        selectionHandler: @handleJamSelection.bind(this, jamIndex, false)
    # add a blank jam for adding a next jam
    jamComponents.push(
      JamItemFactory
        key: @props.teamState.jamStates.length
        jamState: {jamNumber: @props.teamState.jamStates.length+1, passStates: []}
        actions: @bindActions(@props.teamState.jamStates.length)
        style: @props.teamState.colorBarStyle
        selectionHandler: @handleJamSelection.bind(this, @props.teamState.jamStates.length, true)
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
          jamState={@selectedJam()}
          actions={@bindActions(@state.jamSelected)}
          mainMenuHandler={@handleMainMenu}
          prevJamHandler={@handlePreviousJam}
          nextJamHandler={@handleNextJam} />
      </div>
    </div>