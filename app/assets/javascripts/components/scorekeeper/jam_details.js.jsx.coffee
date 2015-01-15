cx = React.addons.classSet
exports = exports ? this
exports.JamDetails = React.createClass
  handleMainMenu: (e) ->
    # console.log e.target
  handlePrev: (e) ->
    # console.log e.target
  handleNext: (e) ->
    # console.log e.target
  render: () ->
    console.log "JamDetails"
    console.log this.props
    nodeId = "#{this.props.teamType}-team-jam-#{this.props.jam.jamNumber}-details"
    jqNodeId = "##{nodeId}"
    jamDetailsClassName = cx
      'hidden-xs': !this.props.jamSelected == this.props.jam.jamNumber

    return(
      `<div  className={jamDetailsClassName}>
          <div className="links">
            <div className="row text-center gutters-xs">
              <div className="col-sm-6 col-xs-6">
                <div className="link main-menu" onClick={this.handleMainMenu}>
                  MAIN MENU
                </div>
              </div>
              <div className="col-sm-6 col-xs-6">
                <div className="row gutters-xs">
                  <div className="col-sm-5 col-xs-5 col-sm-offset-1 col-xs-offset-1">
                    <div className="link prev" onClick={this.handlePrev}>
                      PREV
                    </div>
                  </div>
                  <div className="col-sm-6 col-xs-6">
                    <div className="link next" onClick={this.handleNext}>
                      NEXT
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="jam-details">
            <div className="row gutters-xs">
              <div className="col-sm-3 col-xs-3 col-sm-offset-6 col-xs-offset-6">
                <div className="jam-number">
                  <strong>Jam 5</strong>
                </div>
              </div>
              <div className="col-sm-3 col-xs-3 text-right">
                <div className="jam-total-score">
                  <strong>0</strong>
                </div>
              </div>
            </div>
          </div>
      </div>`
    )
