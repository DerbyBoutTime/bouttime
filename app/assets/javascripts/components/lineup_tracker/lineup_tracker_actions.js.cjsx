cx = React.addons.classSet
exports = exports ? this
exports.LineupTrackerActions = React.createClass
  displayName: 'LineupTrackerActions'
  propTypes:
    endHandler: React.PropTypes.func.isRequired
    undoHandler: React.PropTypes.func.isRequired
  render: () ->
    <div className="row gutters-xs actions">
        <div className="col-sm-6 col-xs-6">
          <button className="actions-action actions-edit text-center bt-btn" onClick={@props.endHandler}>
            NEXT JAM
          </button>
        </div>
        <div className="col-sm-6 col-xs-6">
          <button className="actions-action actions-undo text-center bt-btn" onClick={@props.undoHandler}>
            <strong>UNDO</strong>
          </button>
        </div>
      </div>
