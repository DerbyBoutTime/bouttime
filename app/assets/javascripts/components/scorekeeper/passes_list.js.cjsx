exports = exports ? this
exports.PassesList = React.createClass
  render: () ->
    PassItemFactory = React.createFactory(PassItem)
    passComponents = this.props.passes.map (pass) =>
      PassItemFactory({pass: pass, key: pass.number, teamType: this.props.teamType})

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
