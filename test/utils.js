function currentTime() {
  return Math.round(Date.now() / 1000);
}

function getFutureDate(hours) {
  return Math.round(Date.now() / 1000) + (hours * 60 * 60);
}

module.exports = {
  currentTime,
  getFutureDate,
};
