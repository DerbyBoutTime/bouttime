passMock = jest.genMockFromModule('../pass')
passMock.find.mockImplementation (id) ->
  if typeof id is 'object' then id else undefined
passMock.findBy.mockReturnValue([])
module.exports = passMock