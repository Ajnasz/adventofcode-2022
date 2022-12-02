const assert = require('assert');
const fs = require('fs');
const getSumArray = require('./array');

fs.readFile('./input', (err, data) => {
  if (err) throw err;
  assert.equal(getSumArray(1, data), 69206);
  assert.equal(getSumArray(3, data), 197400);
});
