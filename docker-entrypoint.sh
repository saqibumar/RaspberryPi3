#!/bin/bash
set -exo pipefail

if [[ $1 != "manual" ]]; then
  yarn install --immutable
  lerna run tsc
  lerna run build
  pm2 start ecosystem.dev.config.js
fi

# exec "$@"
tail -f /dev/null