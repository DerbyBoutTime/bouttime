exports = exports ? this
exports.JamsList = React.createClass
  handleMainMenu: (jamNumber) ->
    this.state.jamSelected = null
    this.setState(this.state)
  handleJamSelection: (jamNumber) ->
    this.state.jamSelected = jamNumber
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
        selectionHandler: this.handleJamSelection.bind(this, jam.jamNumber)
        mainMenuHandler: this.handleMainMenu.bind(this, jam.jamNumber)
        nextJamHandler: this.handleNextJam.bind(this, jam.jamNumber)
        prevJamHandler: this.handlePreviousJam.bind(this, jam.jamNumber)
        jamSelected: this.state.jamSelected
        roster: this.props.roster

    # add a blank jam for adding a next jam
    jamComponents.push(
      JamItemFactory
        key: "0"
        jam: {skaterNumber: "Skater", jamNumber: this.props.jams.length+1, passStates: []}
        teamType: this.props.teamType
        selectionHandler: this.handleJamSelection.bind(this, this.props.jams.length+1)
        mainMenuHandler: this.handleMainMenu.bind(this, this.props.jams.length+1)
        nextJamHandler: this.handleNextJam.bind(this, this.props.jams.length+1)
        prevJamHandler: this.handlePreviousJam.bind(this, this.props.jams.length+1)
        jamSelected: this.state.jamSelected
        roster: this.props.roster
    )

    return(
      `<div className="jams">
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
      `
    )
