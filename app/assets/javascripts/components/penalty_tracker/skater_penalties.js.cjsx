cx = React.addons.classSet
exports = exports ? this
exports.SkaterPenalties = React.createClass
  displayName: 'SkaterPenalties'
  propTypes:
    skaterState: React.PropTypes.object.isRequired
    penalties: React.PropTypes.array.isRequired
    applyHandler: React.PropTypes.func
    cancelHandler: React.PropTypes.func
    teamStyle: React.PropTypes.object
    hidden: React.PropTypes.bool

  getInitialState: () ->
    workingSkaterState: $.extend(true, this.props.skaterState)

  render: () ->
    containerClass = cx
      'skater-penalties': true
      'hidden': this.props.hidden

    <div className={containerClass}>
      <div className='row gutters-xs top-buffer actions' >
        <div className='col-sm-6 col-xs-6'>
          <button className='btn btn-block btn-boxed action apply' onClick={this.props.applyHandler.bind(null, this.state.workingSkaterState)} >
            <span className='icon glyphicon glyphicon-ok'></span><strong>Apply</strong>
          </button>
        </div>
        <div className='col-sm-6 col-xs-6'>
          <button className='btn btn-block btn-boxed action cancel' onClick={this.props.cancelHandler}>
            <span className='icon glyphicon glyphicon-remove'></span><strong>Cancel</strong>
          </button>
        </div>
      </div>
      <div className='row gutters-xs top-buffer'>
        <div className='col-sm-2 col-xs-2'>
          <div className='btn btn-block btn-boxed' style={this.props.teamStyle}>
            <strong>{this.props.skaterState.skater.number}</strong>
          </div>
        </div>
      </div>
      <div className='row gutters-xs top-buffer penalty-controls'>
        <div className='col-xs-10 col-sm-10'>
          <div className='row gutters-xs'>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl penaltyNumber={1} penaltyState={this.props.skaterState.penaltyStates[0]} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl penaltyNumber={2} penaltyState={this.props.skaterState.penaltyStates[1]} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl penaltyNumber={3} penaltyState={this.props.skaterState.penaltyStates[2]} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl penaltyNumber={4} penaltyState={this.props.skaterState.penaltyStates[3]} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl penaltyNumber={5} penaltyState={this.props.skaterState.penaltyStates[4]} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl penaltyNumber={6} penaltyState={this.props.skaterState.penaltyStates[5]} />
            </div>
          </div>
        </div>
        <div className='col-xs-2 col-sm-2'>
          <div className='penalty-7'>
            <PenaltyControl penaltyNumber={7} penaltyStates={this.props.skaterState.penaltyStates[6]} />
          </div>
        </div>
      </div>
      <div className='penalties-list'>
        {this.props.penalties[0...-1].map((penalty, penaltyIndex) ->
          <div key={penaltyIndex} className='penalty'>
            <div className='col-xs-1 col-sm-1'>
              <button className='penalty-code btn btn-block btn-boxed'>
                <strong>{penalty.code}</strong>
              </button>
            </div>
            <div className='col-xs-5 col-sm-5'>
              <button className='penalty-name btn btn-block btn-boxed'>
                <strong>{penalty.name}</strong>
              </button>
            </div>
          </div>
        , this).map((elem, i, elems) ->
          if i % 2 then null else <div key={i} className='row gutters-xs top-buffer'>{elems[i..i+1]}</div>
        ).filter (elem) ->
          elem?
        }
        <div className='row gutters-xs top-buffer'>
          <div className='col-xs-1 col-sm-1'>
            <button className='penalty-code btn btn-block btn-boxed'>
              <strong>{this.props.penalties[this.props.penalties.length - 1].code}</strong>
            </button>
          </div>
          <div className='col-xs-11 col-sm-11'>
            <button className='penalty-name btn btn-block btn-boxed'>
              <strong>{this.props.penalties[this.props.penalties.length - 1].name} - Expulsion</strong>
            </button>
          </div>
        </div>
      </div>
    </div>