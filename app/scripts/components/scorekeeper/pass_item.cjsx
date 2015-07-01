React = require 'react/addons'
$ = require 'jquery'
functions = require '../../functions.coffee'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
SkaterSelector = require '../shared/skater_selector.cjsx'
ScoreNote = require './score_note.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PassItem'
  propTypes:
    pass: React.PropTypes.object.isRequired
    panelId: React.PropTypes.string.isRequired
    setSelectorContext: React.PropTypes.func.isRequired
  setJammer: (skaterId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PASS_JAMMER
      passId: @props.pass.id
      skaterId: skaterId
  hidePanels: () ->
    $('.scorekeeper .collapse.in').collapse('hide');
  render: () ->
    notes = @props.pass.getNotes()
    jammer = @props.pass.jammer
    <div className='pass-item'>
      <div className="col-xs-1">
        <div className="bt-box box-primary text-center" >
          {@props.pass.passNumber}
        </div>
      </div>
      <div className="col-xs-2">
          <SkaterSelector
            skater={jammer}
            injured={@props.pass.injury}
            setSelectorContext={@props.setSelectorContext}
            selectHandler={@setJammer} />
      </div>
      <div data-toggle="collapse" data-target={"##{@props.panelId}"} aria-expanded="false" aria-controls={@props.panelId} onClick={@hidePanels}>
        <div className="col-xs-2">
          <ScoreNote note={notes[0]} />
        </div>
        <div className="col-xs-2">
          <ScoreNote note={notes[1]} />
        </div>
        <div className="col-xs-2">
          <ScoreNote note={notes[2]} />
        </div>
        <div className="col-xs-2">
          <div className="bt-box box-default text-center">
            {@props.pass.points ? 0}
          </div>
        </div>
      </div>
    </div>
