exports = exports ? this
exports.JamsList = React.createClass
  render: () ->
    console.log this.props
    JamItemFactory = React.createFactory(JamItem)
    jamComponents = this.props.jams.map (jam) =>
      JamItemFactory({number: this.props.jamNumber, skater: this.props.jammerAttributes.number})
    jamComponents.push(JamItemFactory({number: this.props.jams.length+1, skater: "Skater"}))
    return(
      `<div className="jams">
        <div className="headers">
          <div className="row gutters-xs">
            <div className="col-sm-2 col-xs-2">
              <strong>Jam</strong>
            </div>
            <div className="col-sm-2 col-xs-2">
              <strong>Skater</strong>
            </div>
            <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
              <strong>Notes</strong>
            </div>
            <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
              <strong>Points</strong>
            </div>
          </div>
        </div>
        <div className="columns">
          {jamComponents}
        </div>
      </div>
      `
    )
