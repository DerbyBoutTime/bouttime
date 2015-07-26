Promise = require.requireActual('bluebird')
dispatcherMock = jest.genMockFromModule('../app_dispatcher')
dispatcherMock.waitFor.mockImplementation (ids) ->
  Promise.resolve ids
module.exports = dispatcherMock