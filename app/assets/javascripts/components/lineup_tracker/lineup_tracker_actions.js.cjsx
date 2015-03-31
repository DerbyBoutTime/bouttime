cx = React.addons.classSet
exports = exports ? this
exports.LineupTrackerActions = React.createClass
  displayName: 'LineupTrackerActions'
  propTypes:
    endHandler: React.PropTypes.func.isRequired
  render: () ->
    <div className="row gutters-xs actions">
      <div className="col-sm-12 col-xs-12">
        <button className="actions-action actions-edit text-center bt-btn" onClick={@props.endHandler}>
          NEXT JAM
        </button>
      </div>
    </div>
