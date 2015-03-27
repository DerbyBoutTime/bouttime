cx = React.addons.classSet
exports = exports ? this
exports.PenaltyClock = React.createClass
  displayName: "PenaltyClock"
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