#!/bin/sh

elm-live frontend/Main.elm --start-page=index.html --proxy-prefix=/api --proxy-host=http://localhost:6009 --pushstate -- --debug --output=elm.js
