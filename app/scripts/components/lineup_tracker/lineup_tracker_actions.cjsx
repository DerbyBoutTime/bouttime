React = require 'react/addons'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
functions = require '../../functions.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'LineupTrackerActions'
  propTypes:
    team: React.PropTypes.object.isRequired
  createNextJam: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.CREATE_NEXT_JAM
      teamId: @props.team.id
      jamNumber: @props.team.jams.length + 1
  render: () ->
    <div className="row gutters-xs top-buffer">
      <div className="col-sm-12 col-xs-12">
        <button className="bt-btn btn-primary" onClick={@createNextJam}>
          NEXT JAM
        </button>
      </div>
    </div>
