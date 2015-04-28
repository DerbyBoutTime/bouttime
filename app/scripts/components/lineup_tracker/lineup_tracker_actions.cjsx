React = require 'react/addons'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'LineupTrackerActions'
  propTypes:
    team: React.PropTypes.object.isRequired
  createNextJam: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.CREATE_NEXT_JAM
      teamId: @props.team.id
  render: () ->
    <div className="row gutters-xs actions">
      <div className="col-sm-12 col-xs-12">
        <button className="actions-action actions-edit text-center bt-btn" onClick={@createNextJam}>
          NEXT JAM
        </button>
      </div>
    </div>
