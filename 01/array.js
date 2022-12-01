const { getElfCalories, replaceMax, sum } = require('./lib');

function getElves(input) {
  return input.toString('utf8').split('\n\n').map((elf) => elf.split('\n'));
}

function getTopN(n, items) {
  return items.reduce(replaceMax, new Array(n).fill(0));
}

function getSum(n, file) {
  const maxn = getTopN(n, getElves(file).map(getElfCalories));

  return sum(...maxn);
}

module.exports = getSum;

