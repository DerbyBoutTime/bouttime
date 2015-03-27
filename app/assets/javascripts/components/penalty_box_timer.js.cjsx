cx = React.addons.classSet
exports = exports ? this
exports.PenaltyBoxTimer = React.createClass
  displayName: 'PenaltyBoxTimer'
  mixins: [GameStateMixin, CopyGameStateMixin]
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  render: () ->
    <div className="penalty-box-timer">
      <div className="row gutters-xs hidden-xs hidden-sm">
        <div className="col-xs-6">
          <strong className="clearfix">
            <span className="pull-left">
              Period {@state.gameState.periodNumber}
            </span>
            <span className="pull-right">
              Jam {@state.gameState.jamNumber}
            </span>
          </strong>
          <div className="period-clock">{@state.gameState.periodClockAttributes.display}</div>
        </div>
        <div className="col-xs-6">
          <strong className="jt-label">{@state.gameState.state.replace(/_/g, ' ')}</strong>
          <div className="jam-clock">{@state.gameState.jamClockAttributes.display}</div>
        </div>
      </div>
      <div className="row gutters-xs">
        <div className="col-xs-6">
          <button className="bt-btn undo-btn">UNDO</button>
        </div>
        <div className="col-xs-6">
          <button className="bt-btn edit-btn">
            <span>EDIT</span>
            <i className="glyphicon glyphicon-pencil"></i>
          </button>
        </div>
      </div>
      <div className="row gutters-xs margin-top-05">
        <div className="col-xs-offset-6 col-xs-6">
          <button className="bt-btn .jammer-swap-button">
            <span className="glyphicon glyphicon-star" aria-hidden="true"></span>
            <span>Jammer</span>
          </button>
        </div>
      </div>
      <section className="penalty-clocks">
        <PenaltyClock />
        <PenaltyClock />
        <PenaltyClock />
        <PenaltyClock />
        <PenaltyClock />
      </section>
    </div>
