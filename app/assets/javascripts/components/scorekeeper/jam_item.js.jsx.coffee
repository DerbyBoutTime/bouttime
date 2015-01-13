exports = exports ? this
exports.JamItem = React.createClass
  handleJamSelection: (e) ->
    # console.log e.target

  render: () ->
    console.log "JamItem"
    console.log this.props
    nodeId = "#{this.props.teamType}-team-jam-#{this.props.jam.jamNumber}"
    jqNodeId = "##{nodeId}"

    return(
      `<div className="row gutters-xs" id={nodeId} onClick={this.handleJamSelection}>
        <div className="col-sm-2 col-xs-2">
          <div className="jam text-center">
            {this.props.jam.jamNumber}
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="skater">
            {this.props.jam.skaterNumber}
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="notes injury text-center">
            Injury
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="notes call text-center">
            Call
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="notes lost text-center">
            Lost
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="points text-center">
            10
          </div>
        </div>
      </div>`
    )
