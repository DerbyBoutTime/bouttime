cx = React.addons.classSet
exports = exports ? this
exports.LineupBoxRow = React.createClass
  displayName: 'LineupBoxRow'
  propTypes:
    lineupStatus: React.PropTypes.object
  getDefaultProps: () ->
    lineupStatus:
      pivot: 'clear'
      blocker1: 'clear'
      blocker2: 'clear'
      blocker3: 'clear'
      jammer: 'clear'
  render: () ->
    <div className="row gutters-xs boxes">
        <div className="col-5-cols">
          <LineupBox status={this.props.lineupStatus.jammer} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, 'jammer')} />
        </div>
        <div className="col-5-cols">
          <LineupBox status={this.props.lineupStatus.pivot} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, 'pivot')} />
        </div>
        <div className="col-5-cols">
          <LineupBox status={this.props.lineupStatus.blocker1} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, 'blocker1')} />
        </div>
        <div className="col-5-cols">
          <LineupBox status={this.props.lineupStatus.blocker2} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, 'blocker2')} />
        </div>
        <div className="col-5-cols">
          <LineupBox status={this.props.lineupStatus.blocker3} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, 'blocker3')} />
        </div>
      </div>