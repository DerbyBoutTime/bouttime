React = require 'react/addons'
PassesList = require './passes_list.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamDetails'
  propType:
    jam: React.PropTypes.object.isRequired
    setSelectorContext: React.PropTypes.func.isRequired
    mainMenuHandler: React.PropTypes.func
    prevJamHandler: React.PropTypes.func
    nextJamHandler: React.PropTypes.func
  render: () ->
    <div className="jam-details">
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-6">
          <button className="bt-btn btn-primary text-uppercase" onClick={@props.mainMenuHandler}>
            Main Menu
          </button>
        </div>
        <div className="col-xs-3">
         <button className="bt-btn btn-primary text-uppercase" onClick={@props.prevJamHandler}>
            Prev
          </button>
        </div>
        <div className="col-xs-3">
          <button className="bt-btn btn-primary text-uppercase" onClick={@props.nextJamHandler}>
            Next
          </button>
        </div>
      </div>
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-6 col-xs-offset-6">
          <div className="bt-box">
            <div className="row gutters-xs">
              <div className="col-xs-9">
                Jam {@props.jam.jamNumber}
              </div>
              <div className="col-xs-3 text-right">
                {@props.jam.getPoints()}
              </div>
            </div>
          </div>
        </div>
      </div>
      <PassesList {...@props}/>
    </div>
