cx = React.addons.classSet
exports = exports ? this
exports.JamDetails = React.createClass
  displayName: 'JamDetails'
  propType:
    jamState: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired
    mainMenuHandler: React.PropTypes.func
    prevJamHandler: React.PropTypes.func
    nextJamHandler: React.PropTypes.func
  totalPoints: () ->
    points = 0
    @props.jamState.passStates.map (pass) =>
      points += pass.points || 0
    return points
  render: () ->
    <div className="jam-details-container">
      <div className="links">
        <div className="row text-center gutters-xs">
          <div className="col-sm-6 col-xs-6">
            <button className="main-menu link bt-btn" onClick={@props.mainMenuHandler}>
              Main Menu
            </button>
          </div>
          <div className="col-sm-3 col-xs-3">
           <button className="prev link bt-btn" onClick={@props.prevJamHandler}>
              Prev
            </button>
          </div>
          <div className="col-sm-3 col-xs-3">
            <button className="next link bt-btn" onClick={@props.nextJamHandler}>
              Next
            </button>
          </div>
        </div>
      </div>
      <div className="jam-details">
        <div className="row gutters-xs">
          <div className="col-sm-3 col-xs-3 col-sm-offset-6 col-xs-offset-6">
            <div className="jam-number">
              <strong>Jam {@props.jamState.jamNumber}</strong>
            </div>
          </div>
          <div className="col-sm-3 col-xs-3 text-right">
            <div className="jam-total-score">
              <strong>{@totalPoints()}</strong>
            </div>
          </div>
        </div>
      </div>
      <PassesList jamState={@props.jamState}
        actions={@props.actions}/>
    </div>
