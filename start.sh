#!/bin/bash

trap 'killAll' INT

killAll() {
  # Return a zero exit code even though we were interrupted.
  exit 0
}

WEBPACK='node_modules/.bin/webpack'
NODE='node'

# Uncomment this if you have trouble using Ctrl+C to shutdown server on windows.
#if command -v winpty &> /dev/null; then
#  NODE='winpty node'
#fi

# winpty doesn't convert LF to CRLF automatically.  So, we insert CR manually.
CR=$(printf '\r')
NODE_ENV=development $WEBPACK --watch --config webpack.config.cjs | sed "s/\$/$CR/" &

# Wait for the node server to terminate
$NODE --es-module-specifier-resolution=node --require dotenv/config src/server.js

# Stop all child processes like webpack and sed
kill -INT 0
