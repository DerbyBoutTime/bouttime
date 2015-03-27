cx = React.addons.classSet
exports = exports ? this
exports.PenaltyClock = React.createClass
  displayName: "PenaltyClock"
  propTypes:
    state: React.PropTypes.object.isRequired
    skater: React.PropTypes.object.isRequired
    alert: React.PropTypes.object.isRequired
    served: React.PropTypes.object.isRequired
    clock: React.PropTypes.object.isRequired
  render: () ->
    <div className="penalty-clock">
      <div className="skater-wrapper">
        <div className="skater-dropdown">
          <button className="bt-btn select-skater-button">
            <span>Skater Name</span>
            <span className="glyphicon glyphicon-chevron-down"></span>
          </button>
        </div>
        <div className="skater-data">
          <button className="left-early-button">Early</button>
          <button className="served-button">
            <span className="glyphicon glyphicon-ok"></span>
          </button>
        </div>
      </div>
      <div className="col-xs-6">
        <div className="clock">00</div>
      </div>
    </div>