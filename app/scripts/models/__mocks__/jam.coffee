jamMock = jest.genMockFromModule('../jam')
jamMock.findBy.mockReturnValue([])
jamMock.prototype.getPositionsInBox.mockReturnValue([])
module.exports = jamMock