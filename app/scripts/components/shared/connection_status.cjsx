React = require 'react/addons'
cx = React.addons.classSet
AppDispatcher = require '../../dispatcher/app_dispatcher'
module.exports = React.createClass
  displayName: 'ConnectionStatus'
  mixins: [React.addons.PureRenderMixin]
  getInitialState: () ->
    connected: AppDispatcher.isConnected()
  componentDidMount: () ->
    AppDispatcher.addConnectionListener @onChange
  componentWillUnmount: () ->
    AppDispatcher.removeConnectionListener @onChange
  onChange: () ->
    @setState @getInitialState()
  render: () ->
    iconClass = cx
      'glyphicon': true
      'glyphicon-ok-sign': @state.connected
      'glyphicon-remove-sign': not @state.connected
      'connection-status': true
      'good-status': @state.connected
      'bad-status': not @state.connected
    <span className={iconClass}></span>
