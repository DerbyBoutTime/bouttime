React = require 'react/addons'
module.exports = React.createClass
  displayName: 'JamAndPeriodNumbers'
  render: () ->
    <div className="row">
      <div className="col-xs-12">
        <strong>
          <span className="jt-label pull-left" onClick={@props.clickPeriodEdit}>
            Period {@props.periodNumber}
          </span>
          <span className="jt-label pull-right" onClick={@props.clickJamEdit}>
            Jam {@props.jamNumber}
          </span>
        </strong>
      </div>
    </div>