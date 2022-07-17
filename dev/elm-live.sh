#!/bin/sh

(
  cd static &&
    elm-live ../src/Main.elm --start-page=index.html --proxy-prefix=/api --proxy-host=http://localhost:6009 --pushstate -- --debug --output=elm.js
)
