clockMock = jest.genMockFromModule('../clock')
clockMock.ClockManager.prototype.getOrAddClock.mockImplementation () ->
  new clockMock.Clock()
clockMock.ClockManager.prototype.addClock.mockImplementation () ->
  new clockMock.Clock()
module.exports = clockMock