exports = exports ? this
exports.PassesList = React.createClass
  displayName: 'PassesList'
  propTypes:
    jamState: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired
  bindActions: (passIndex) ->
    Object.keys(@props.actions).map((key) ->
      key: key
      value: @props.actions[key].bind(this, passIndex)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
  mouseDownHandler: (evt) ->
    @target = evt.target
  dragHandler: (passIndex, evt) ->
    if $(@target).hasClass('drag-handle') or $(@target).parents('.drag-handle').length > 0
      evt.dataTransfer.setData 'passIndex', passIndex
    else
      evt.preventDefault()
  dropHandler: (passIndex, evt) ->
    sourceIndex = evt.dataTransfer.getData 'passIndex'
    @props.actions.reorderPass(sourceIndex, passIndex)
  render: () ->
    PassItemFactory = React.createFactory(PassItem)
    passComponents = @props.jamState.passStates.map (passState, passIndex) =>
      PassItemFactory(
        key: passIndex
        jamState: @props.jamState
        passState: passState
        actions: @bindActions(passIndex)
        setSelectorContext: @props.actions.setSelectorContext #Without binding passIndex
        dragHandler: @dragHandler.bind(this, passIndex)
        dropHandler: @dropHandler.bind(this, passIndex)
        mouseDownHandler: @mouseDownHandler
      )
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
      {passComponents}
    </div>
