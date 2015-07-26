React = require 'react/addons'
Mousetrap = require 'mousetrap'
module.exports = React.createClass
  displayName: 'ShortcutButton'
  propTypes:
    shortcut: React.PropTypes.string
  componentDidMount: () ->
    Mousetrap.bind @props.shortcut, @props.onClick
  componentWillUnmount: () ->
    Mousetrap.unbind @props.shortcut
  render: () ->
    <button {...@props}>
      {@props.children}
    </button>
