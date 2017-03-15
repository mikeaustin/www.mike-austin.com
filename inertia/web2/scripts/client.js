
onmessage = function(event) {
  if (this[event.data]) {
    this[event.data]();
  }
}

function start() {
  postMessage("yay!");
}

