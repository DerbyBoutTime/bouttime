Promise = require.requireActual('bluebird')
teamMock = jest.genMockFromModule('../team')
teamMock.findOrCreate.mockImplementation (opts) ->
  Promise.resolve(new teamMock(opts))
module.exports = teamMock