clockMock = jest.genMockFromModule('../clock')
clocks = {}
clockMock.ClockManager.prototype.getOrAddClock.mockImplementation (alias) ->
  clocks[alias] ? clocks[alias] = new clockMock.Clock()
module.exports = clockMock