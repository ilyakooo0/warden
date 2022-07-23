export function startElm(element) {
  return function () {
    return Elm.Main.init({
      node: document.getElementById(element)
    })
  }
}

export function createElmSubscription(elm) {
  return function (name) {
    return function (callback) {
      return function () {
        elm.ports[name].subscribe(function (message) { callback(message)() })
      }
    }
  }
}

export function sendElmEvent(elm) {
  return function (name) {
    return function (value) {
      return function () { elm.ports[name].send(value) }
    }
  }
}
