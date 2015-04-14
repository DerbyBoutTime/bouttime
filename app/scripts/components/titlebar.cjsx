React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: "TitleBar"
  componentDidMount: () ->
    $dom = $(@getDOMNode())
  getInitialState: () ->
    @props
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
                  <a id="login" href="#"> Sign In</a>
                </li>
                <li>
                  <a id="setup" href="#"> Setup</a>
                </li>
              </ul>
            </div>
            <span className="gamename">{@props.id}</span>
            <span className="glyphicon glyphicon-ok-sign good-status"></span>
            <span className="glyphicon glyphicon-remove-sign bad-status"></span>
          </div>
        </div>
      </div>
    </div>
