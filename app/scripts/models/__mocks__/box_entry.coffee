Promise = require.requireActual('bluebird')
boxMock = jest.genMockFromModule('../box_entry')
boxMock.find.mockImplementation (id) ->
  Promise.resolve id: id
boxMock.findBy.mockReturnValue (Promise.resolve([]))
boxMock.findByOrCreate.mockImplementation (query, opts) ->
  Promise.resolve(new boxMock(opts) for opt in opts)
boxMock.findOrCreate.mockImplementation (opts) ->
  Promise.resolve(new boxMock(opts))
boxMock.new.mockImplementation (opts) ->
  Promise.resolve(new boxMock(opts))
module.exports = boxMock