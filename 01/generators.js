const { getElfCalories, replaceMax, sum } = require('./lib');

function *getLines(inputStr) {
  let str = inputStr;
  while (str.length > 0) {
    const idx = str.indexOf('\n');
    const line = str.slice(0, idx);
    str = str.slice(idx + 1);
    yield line
  }
}

function *getElves(lines) {
  let elf = [];
  for (const line of lines) {
    if (line === '') {
      yield elf;
      elf = [];
    } else {
      elf.push(line);
    }
  }
}

function *map(fn, generator) {
  for (const item of generator) {
    yield fn(item);
  }
}

function reduce(fn, init, generator) {
  for (const item of generator) {
    init = fn(init, item);
  }
  return init;
}

function getTopN(n, items) {
  return reduce(replaceMax, new Array(n).fill(0), items);
}

function getSum(n, file) {
  const maxn = getTopN(n, map(getElfCalories, getElves(getLines(file.toString('utf8')))));

  return sum(...maxn);
}

module.exports = getSum;
