passMock = jest.genMockFromModule('../pass')
passMock.find.mockImplementation (id) ->
  id
passMock.findBy.mockReturnValue([])
module.exports = passMock