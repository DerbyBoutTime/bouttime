Promise = require.requireActual 'bluebird'
passMock = jest.genMockFromModule('../pass')
passMock.find.mockImplementation (id) ->
  Promise.resolve(if typeof id is 'object' then id else null)
passMock.findBy.mockReturnValue(Promise.resolve([]))
passMock.findByOrCreate.mockImplementation (query, opts) ->
  Promise.resolve(new passMock(opts) for opt in opts)
passMock.findOrCreate.mockImplementation (opts) ->
  Promise.resolve(new passMock(opts))
module.exports = passMock