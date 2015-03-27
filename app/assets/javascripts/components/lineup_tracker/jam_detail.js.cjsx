cx = React.addons.classSet
exports = exports ? this
exports.JamDetail = React.createClass
  displayName: 'JamDetail'
  propTypes:
    teamAttributes: React.PropTypes.object.isRequired
    jamState: React.PropTypes.object.isRequired
    noPivotHandler: React.PropTypes.func.isRequired
    starPassHandler: React.PropTypes.func.isRequired
    lineupStatusHandler: React.PropTypes.func.isRequired
    setSelectorContextHandler: React.PropTypes.func.isRequired
    selectSkaterHandler: React.PropTypes.func.isRequired
  isInjured: (position) ->
    this.props.jamState.lineupStatuses.some (status) ->
      status[position] is 'injured'
  render: () ->
    noPivotButtonClass = cx
      'btn': true
      'btn-block': true
      'jam-detail-no-pivot': true
      'toggle-pivot-btn': true
      'selected': this.props.jamState.noPivot
    starPassButtonClass = cx
      'btn': true
      'btn-block': true
      'jam-detail-star-pass': true
      'toggle-star-pass-btn': true
      'selected': this.props.jamState.starPass
    actionsClass = cx
      'row': true
      'gutters-xs': true
      'actions': true
    <div className="jam-detail">
      <div className="row gutters-xs">
        <div className="col-sm-8 col-xs-8">
          <div className="jam-detail-number boxed-good">
            <div className="row gutters-xs">
              <div className="col-sm-11 col-xs-11 col-sm-offset-1 col-xs-offset-1">
                Jam {this.props.jamState.jamNumber}
              </div>
            </div>
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <button className={noPivotButtonClass} onClick={this.props.noPivotHandler}>
            <strong>No Pivot</strong>
          </button>
        </div>
        <div className="col-sm-2 col-xs-2">
          <button className={starPassButtonClass} onClick={this.props.starPassHandler}>
            <strong><span className="glyphicon glyphicon-star" aria-hidden="true"></span> Pass</strong>
          </button>
        </div>
      </div>
      <div className="row gutters-xs positions">
        <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
          <strong>J</strong>
        </div>
        <div className="col-sm-2 col-xs-2 text-center">
          <strong>Pivot</strong>
        </div>
        <div className="col-sm-2 col-xs-2 text-center">
          <strong>B1</strong>
        </div>
        <div className="col-sm-2 col-xs-2 text-center">
          <strong>B2</strong>
        </div>
        <div className="col-sm-2 col-xs-2 text-center">
          <strong>B3</strong>
        </div>
      </div>
      <div className="row gutters-xs skaters">
        <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2">
          <SkaterSelector
            skater={this.props.jamState.jammer}
            injured={this.isInjured('jammer')}
            style={this.props.teamAttributes.colorBarStyle}
            setSelectorContext={this.props.setSelectorContextHandler}
            selectHandler={this.props.selectSkaterHandler.bind(this, 'jammer')} />        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector
            skater={this.props.jamState.pivot}
            injured={this.isInjured('pivot')}
            style={this.props.teamAttributes.colorBarStyle}
            setSelectorContext={this.props.setSelectorContextHandler}
            selectHandler={this.props.selectSkaterHandler.bind(this, 'pivot')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector
            skater={this.props.jamState.blocker1}
            injured={this.isInjured('blocker1')}
            style={this.props.teamAttributes.colorBarStyle}
            setSelectorContext={this.props.setSelectorContextHandler}
            selectHandler={this.props.selectSkaterHandler.bind(this, 'blocker1')} />        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector
            skater={this.props.jamState.blocker2}
            injured={this.isInjured('blocker2')}
            style={this.props.teamAttributes.colorBarStyle}
            setSelectorContext={this.props.setSelectorContextHandler}
            selectHandler={this.props.selectSkaterHandler.bind(this, 'blocker2')} />        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector
            skater={this.props.jamState.blocker3}
            injured={this.isInjured('blocker3')}
            style={this.props.teamAttributes.colorBarStyle}
            setSelectorContext={this.props.setSelectorContextHandler}
            selectHandler={this.props.selectSkaterHandler.bind(this, 'blocker3')} />        </div>
      </div>
      {this.props.jamState.lineupStatuses.map (lineupStatus, statusIndex) ->
        <LineupBoxRow key={statusIndex} lineupStatus=lineupStatus lineupStatusHandler={this.props.lineupStatusHandler.bind(this, statusIndex)} />
      , this }
      <LineupBoxRow key={this.props.jamState.lineupStatuses.length} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, this.props.jamState.lineupStatuses.length)} />
    </div>
