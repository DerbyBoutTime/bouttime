module.exports = class MemoryStorage
  setItem: (id, val) -> this[id] = val
  getItem: (id) -> this[id]
  removeItem: (id) -> delete this[id]