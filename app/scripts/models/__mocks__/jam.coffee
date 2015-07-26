Promise = require.requireActual('bluebird')
jamMock = jest.genMockFromModule('../jam')
jamMock.find.mockImplementation (id) ->
  Promise.resolve(if typeof id is 'object' then id else null)
jamMock.findBy.mockReturnValue(Promise.resolve([]))
jamMock.findByOrCreate.mockImplementation (query, opts) ->
  Promise.resolve(new jamMock(opts) for opt in opts)
jamMock.findOrCreate.mockImplementation (opts) ->
  Promise.resolve(new jamMock(opts))
jamMock.prototype.getPositionsInBox.mockReturnValue([])
module.exports = jamMock