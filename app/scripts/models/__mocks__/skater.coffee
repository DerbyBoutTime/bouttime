skaterMock = jest.genMockFromModule('../skater')
skaterMock.find.mockImplementation (id) ->
  id
skaterMock.findBy.mockReturnValue ([])
module.exports = skaterMock