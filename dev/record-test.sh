#!/bin/sh

set -e

cd tests

npm install

export RECORD_TEST=true

npx playwright test
