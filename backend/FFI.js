function searchForInit(obj) {
  if (obj.init) {
    return obj.init
  } else {
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        const result = searchForInit(obj[key])
        if (result) {
          return result
        }
      }
    }
  }
}

export function startElm(element) {
  return function () {
    return searchForInit(Elm)({
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
