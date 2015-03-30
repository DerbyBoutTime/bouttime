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
          <LineupBox status={@props.lineupStatus.jammer} lineupStatusHandler={@props.lineupStatusHandler.bind(this, 'jammer')} />
        </div>
        <div className="col-5-cols">
          <LineupBox status={@props.lineupStatus.pivot} lineupStatusHandler={@props.lineupStatusHandler.bind(this, 'pivot')} />
        </div>
        <div className="col-5-cols">
          <LineupBox status={@props.lineupStatus.blocker1} lineupStatusHandler={@props.lineupStatusHandler.bind(this, 'blocker1')} />
        </div>
        <div className="col-5-cols">
          <LineupBox status={@props.lineupStatus.blocker2} lineupStatusHandler={@props.lineupStatusHandler.bind(this, 'blocker2')} />
        </div>
        <div className="col-5-cols">
          <LineupBox status={@props.lineupStatus.blocker3} lineupStatusHandler={@props.lineupStatusHandler.bind(this, 'blocker3')} />
        </div>
      </div>