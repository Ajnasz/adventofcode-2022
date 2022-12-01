function replaceMax(max, m) {
  const lessIndex = max.findIndex((item) => item < m);
  if (lessIndex === -1) {
    return max;
  }

  max.splice(lessIndex, 0, m)
  return max.slice(0, -1);
}

function sum(...args) {
  return args.reduce((out, i) => i + out, 0);
}

function getElfCalories(elf) {
  return elf
    .map((n) => Number.parseInt(n)).reduce((r, i) => r + i);
}

module.exports.replaceMax = replaceMax;
module.exports.sum = sum;
module.exports.getElfCalories = getElfCalories;
