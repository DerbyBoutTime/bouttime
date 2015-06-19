React = require 'react/addons'
functions = require '../../functions'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
ItemRow = require './item_row'
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
    <div className="passes">
      <div className="headers">
        <div className="row gutters-xs">
          <div className="col-sm-11 col-xs-11 col-sm-offset-1 col-xs-offset-1">
            <div className="col-sm-2 col-xs-2">
              Pass
            </div>
            <div className="col-sm-2 col-xs-2">
              Skater
            </div>
            <div className="col-sm-2 col-xs-2"></div>
            <div className="col-sm-2 col-xs-2 text-center">
              Notes
            </div>
            <div className="col-sm-2 col-xs-2"></div>
            <div className="col-sm-2 col-xs-2 text-center">
              Points
            </div>
          </div>
        </div>
      </div>
      <div className="columns">
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
      </div>
      <div className="actions">
        <div className="row gutters-xs">
          <div className="col-sm-12 col-xs-12">
            <button className="bt-btn action" onClick={@createNextPass}>Next Pass</button>
          </div>
        </div>
      </div>
    </div>
