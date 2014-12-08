exports = exports ? this
exports.JamTimer = React.createClass
  getInitialState: () ->
    null
  render: () ->
    `<div id="jam-timer-view">
      <div className="row text-center">
        <div className="col-md-2 col-xs-2">
          <div className="timeout-bars away">
            <span className="jt-label">AWAY</span>
            <div className="bar disabled">0</div>
            <div className="bar"/>
            <div className="bar"/>
            <div className="bar"/>
        </div>
      </div>
      <div className="col-md-8 col-xs-8">
        <div className="row">
          <div className="col-md-8 col-xs-8 col-md-offset-2 col-xs-offset-2">
            <strong>
              <span className="jt-label pull-left">Period 1</span>
              <span className="jt-label pull-right">Jam 1</span>
            </strong>
          </div>
          <div className="col-md-12 col-xs-12">
            <div className="game-clock">30:00</div>
          </div>
          <div className="col-md-12 col-xs-12">
            <strong className="jt-label">Jam Clock</strong>
            <div className="jam-clock">2:00<span className="seconds">:00</span>
          </div>
        </div>
      </div>
    </div>
    <div className="col-md-2 col-xs-2">
      <div className="timeout-bars home">
        <span className="jt-label">HOME</span>
        <div className="bar">0</div>
        <div className="bar"></div>
        <div className="bar"></div>
        <div className="bar"></div>
      </div>
    </div>
    </div>
    <div className="text-center row">
      <div className="col-md-4 col-xs-4">
        <div className="away">
          <div className="row">
            <div className="col-md-12 col-xs-12">
              <button className="btn btn-block">TIMEOUT</button>
            </div>
          </div>
          <div className="row margin-top-05">
            <div className="col-md-12 col-xs-12">
              <button className="btn btn-block">OFF. REVIEW</button>
            </div>
          </div>
        </div>
      </div>
      <div className="col-md-4 col-xs-4">
        <div className="official-timeout">OFFICIAL TIMEOUT</div>
      </div>
      <div className="col-md-4 col-xs-4">
        <div className="home">
          <div className="row">
            <div className="col-md-12 col-xs-12">
              <button className="btn btn-block">TIMEOUT</button>
            </div>
          </div>
          <div className="row margin-top-05">
            <div className="col-md-12 col-xs-12">
              <button className="btn btn-block">OFF. REVIEW</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div className="row margin-top-05">
      <div className="col-md-6 col-xs-6">
        <button className="btn btn-lg btn-block">STOP CLOCK</button>
      </div>
      <div className="col-md-6 col-xs-6">
        <button className="btn btn-lg btn-block">UNDO</button>
      </div>
    </div>
    <div className="row margin-top-05">
      <div className="col-md-12 col-xs-12">
        <button className="btn-start-jam">START JAM</button>
      </div>
    </div>
    </div>
`