React = require 'react/addons'
PassesList = require './passes_list.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamDetails'
  propType:
    jam: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired
    mainMenuHandler: React.PropTypes.func
    prevJamHandler: React.PropTypes.func
    nextJamHandler: React.PropTypes.func
  totalPoints: () ->
    points = 0
    @props.jam.passes.map (pass) =>
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
              <strong>Jam {@props.jam.jamNumber}</strong>
            </div>
          </div>
          <div className="col-sm-3 col-xs-3 text-right">
            <div className="jam-total-score">
              <strong>{@totalPoints()}</strong>
            </div>
          </div>
        </div>
      </div>
      <PassesList jam={@props.jam}
        actions={@props.actions}/>
    </div>
