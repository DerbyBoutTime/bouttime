React = require 'react/addons'
cx = React.addons.classSet
ConnectionStatus = require './shared/connection_status'
module.exports = React.createClass
  displayName: "TitleBar"
  render: () ->
    <div className="title-bar">
      <div className="container">
        <div className="row">
          <div className="col-xs-12 col-sm-12">
            <div className="btn-group">
              <a className="btn-title-menu btn btn-default dropdown-toggle" data-toggle="dropdown" href="#">
                <img alt="menu" src="/images/icons/menu.svg" />
              </a>
              <ul className="dropdown-menu">
                <li>
                  <a id="login" onClick={@props.tabHandler.bind(null, 'login')}> Sign In</a>
                </li>
                <li>
                  <a id="setup" onClick={@props.tabHandler.bind(null, 'game_setup')}> Setup</a>
                </li>
                <li>
                  <a id="back" onClick={@props.backHandler}> Back</a>
                </li>
                <li>
                  <a href="/export/#{@props.gameStateId}"> Export</a>
                </li>
              </ul>
            </div>
            <span className="gamename">{@props.gameName}</span>
            <ConnectionStatus />
          </div>
        </div>
      </div>
    </div>
