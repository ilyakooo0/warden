#!/bin/sh

set -e

cd tests

npm install

npx playwright test
