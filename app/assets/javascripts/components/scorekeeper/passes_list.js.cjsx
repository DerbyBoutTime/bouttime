exports = exports ? this
exports.PassesList = React.createClass
  displayName: 'PassesList'
  propTypes:
    passStates: React.PropTypes.array.isRequired
    actions: React.PropTypes.object.isRequired

  bindActions: (passIndex) ->
    Object.keys(this.props.actions).map((key) ->
      key: key
      value: this.props.actions[key].bind(this, passIndex)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})

  render: () ->
    PassItemFactory = React.createFactory(PassItem)
    passComponents = this.props.passStates.map (passState, passIndex) =>
      PassItemFactory(
        key: passIndex
        passState: passState
        actions: this.bindActions(passIndex)
      )

    <div className="passes">
      <div className="headers">
        <div className="row gutters-xs">
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
      {passComponents}
    </div>
