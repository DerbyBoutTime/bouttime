cx = React.addons.classSet
exports = exports ? this
exports.JamsList = React.createClass
  displayName: 'JamsList'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired

  bindActions: (jamIndex) ->
    Object.keys(this.props.actions).map((key) ->
      key: key
      value: this.props.actions[key].bind(this, jamIndex)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})

  selectedJam: () ->
    this.props.teamState.jamStates[this.state.jamSelected || 0]

  handleMainMenu: () ->
    this.setState(jamSelected: null)

  handleJamSelection: (jamIndex, newJam) ->
    if newJam
      this.props.actions.newJam(jamNumber: this.props.teamState.jamStates.length + 1, passStates: [passNumber: 1, sort: 0])
    this.setState(jamSelected: jamIndex)

  handleNextJam: () ->
    if this.state.jamSelected < this.props.teamState.jamStates.length - 1
      this.setState(jamSelected: this.state.jamSelected + 1)

  handlePreviousJam: () ->
    if this.state.jamSelected > 0
      this.setState(jamSelected: this.state.jamSelected - 1)

  getInitialState: () ->
    jamSelected: null

  render: () ->
    JamItemFactory = React.createFactory(JamItem)
    # jam's schema is same as jam_state table
    jamComponents = this.props.teamState.jamStates.map (jamState, jamIndex) =>
      JamItemFactory
        key: jamIndex
        jamState: jamState
        selectionHandler: this.handleJamSelection.bind(this, jamIndex, false)

    # add a blank jam for adding a next jam
    jamComponents.push(
      JamItemFactory
        key: this.props.teamState.jamStates.length
        jamState: {jamNumber: this.props.teamState.jamStates.length+1, passStates: []}
        selectionHandler: this.handleJamSelection.bind(this, this.props.teamState.jamStates.length, true)
    )

    jamsContainerClass = cx
      'jams': true
      'hidden': this.state.jamSelected?

    passesContainerClass = cx
      'passes-container': true
      'hidden': not this.state.jamSelected?

    <div>
      <div className={jamsContainerClass}>
        <div className="headers">
          <div className="row gutters-xs">
            <div className="col-sm-2 col-xs-2">
              <strong>Jam</strong>
            </div>
            <div className="col-sm-2 col-xs-2">
              <strong>Skater</strong>
            </div>
            <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
              <strong>Notes</strong>
            </div>
            <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
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
          jamState={this.selectedJam()}
          actions={this.bindActions(this.state.jamSelected)}
          mainMenuHandler={this.handleMainMenu}
          prevJamHandler={this.handlePreviousJam}
          nextJamHandler={this.handleNextJam} />
      </div>
    </div>