cx = React.addons.classSet
exports = exports ? this
exports.GameSetup = React.createClass
  displayName: 'GameSetup'
  render: () ->
    <div className="game-setup">
      <GameForm />
    </div>