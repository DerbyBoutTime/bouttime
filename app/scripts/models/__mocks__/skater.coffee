Promise = require.requireActual('bluebird')
skaterMock = jest.genMockFromModule('../skater')
skaterMock.find.mockImplementation (id) ->
  Promise.resolve(id)
skaterMock.findBy.mockReturnValue (Promise.resolve([]))
skaterMock.findByOrCreate.mockImplementation (query, opts) ->
  Promise.resolve(new skaterMock(opts) for opt in opts)
skaterMock.findOrCreate.mockImplementation (opts) ->
  Promise.resolve(new skaterMock(opts))
module.exports = skaterMock