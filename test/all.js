exports['test that logs all failures'] = function(assert) {
  assert.equal(3 + 2, 5, 'assert pass is logged')
}

if (module == require.main) require('test').run(exports)