export function startElm(element) {
  Elm.Main.init({
    node: document.getElementById(element)
  })
}
