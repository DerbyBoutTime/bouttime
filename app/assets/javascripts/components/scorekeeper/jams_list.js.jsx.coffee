cx = React.addons.classSet
exports = exports ? this
exports.JamsList = React.createClass
  getStandardOptions: (opts = {}) ->
    std_opts =
      time: new Date()
      role: 'Scorekeeper'
      state: this.state
    $.extend(std_opts, opts)

  handleMainMenu: (jamNumber) ->
    this.state.jamSelected = null
    this.setState(this.state)
  handleJamSelection: (jamNumber, newJam) ->
    this.state.jamSelected = jamNumber
    if newJam
      dispatcher.trigger 'scorekeeper.create_jam', this.getStandardOptions(team: this.state.teamType, jamNumber: jamNumber)
    this.setState(this.state)
  handleNextJam: (jamNumber) ->
    if jamNumber < this.props.jams.length+1
      this.state.jamSelected = jamNumber + 1
      this.setState(this.state)
  handlePreviousJam: (jamNumber) ->
    if jamNumber > 1
      this.state.jamSelected = jamNumber - 1
      this.setState(this.state)

  getInitialState: () ->
    this.state = this.props

  render: () ->
    JamItemFactory = React.createFactory(JamItem)
    # jam's schema is same as jam_state table
    jamComponents = this.props.jams.map (jam) =>
      JamItemFactory
        key: jam.jamNumber
        jam: jam
        teamType: this.props.teamType
        selectionHandler: this.handleJamSelection.bind(this, jam.jamNumber, false)
        mainMenuHandler: this.handleMainMenu.bind(this, jam.jamNumber)
        nextJamHandler: this.handleNextJam.bind(this, jam.jamNumber)
        prevJamHandler: this.handlePreviousJam.bind(this, jam.jamNumber)
        updateTeamPoints: this.props.updateTeamPoints
        jamSelected: this.state.jamSelected
        roster: this.props.roster

    # add a blank jam for adding a next jam
    jamComponents.push(
      JamItemFactory
        key: "0"
        jam: {skaterNumber: "Skater", jamNumber: this.props.jams.length+1, passStates: []}
        teamType: this.props.teamType
        selectionHandler: this.handleJamSelection.bind(this, this.props.jams.length+1, true)
        mainMenuHandler: this.handleMainMenu.bind(this, this.props.jams.length+1)
        nextJamHandler: this.handleNextJam.bind(this, this.props.jams.length+1)
        prevJamHandler: this.handlePreviousJam.bind(this, this.props.jams.length+1)
        updateTeamPoints: this.props.updateTeamPoints
        jamSelected: this.state.jamSelected
        roster: this.props.roster
    )

    jamHeadersClassName = cx
      'headers': true
      'hidden-xs': this.state.jamSelected

    return(
      `<div className="jams">
        <div className={jamHeadersClassName}>
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
      `
    )
