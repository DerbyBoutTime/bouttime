React = require 'react/addons'
functions = require '../../functions'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
ItemRow = require '../shared/item_row'
PassItem = require './pass_item'
PassEditPanel = require './pass_edit_panel'
module.exports = React.createClass
  displayName: 'PassesList'
  propTypes:
    jam: React.PropTypes.object.isRequired
    setSelectorContext: React.PropTypes.func.isRequired
  reorderHandler: (sourceIndex, targetIndex) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.REORDER_PASS
      jamId: @props.jam.id
      sourcePassIndex: sourceIndex
      targetPassIndex: targetIndex
  removeHandler: (passId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.REMOVE_PASS
      jamId: @props.jam.id
      passId: passId
  createNextPass: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.CREATE_NEXT_PASS
      jamId: @props.jam.id
      passNumber: @props.jam.passes.length + 1
  render: () ->
    <div className="passes-list">
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-11 col-xs-offset-1">
          <div className="col-xs-2 text-center">
            <strong>Pass</strong>
          </div>
          <div className="col-xs-2 text-center">
            <strong>Skater</strong>
          </div>
          <div className="col-xs-2 col-xs-offset-2 text-center">
            <strong>Notes</strong>
          </div>
          <div className="col-xs-2 col-xs-offset-2 text-center">
            <strong>Points</strong>
          </div>
        </div>
      </div>
      {@props.jam.passes.map (pass, passIndex) ->
        args =
          pass: pass
          jam: @props.jam
          panelId: "edit-pass-#{functions.uniqueId()}"
          setSelectorContext: @props.setSelectorContext
        item = <PassItem {...args} />
        panel = <PassEditPanel {...args} />
        <ItemRow
          key={pass.id}
          item={item}
          panel={panel}
          index={passIndex}
          reorderHandler={@reorderHandler}
          removeHandler={@removeHandler.bind(this, pass.id)} />
      , this}
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-12">
          <button className="bt-btn btn-primary text-uppercase" onClick={@createNextPass}>Next Pass</button>
        </div>
      </div>
    </div>
