#!/usr/bin/env bash

set -euo pipefail

if [ -z "${FPM_SOCKET_ADDR:-}" ]; then
    echo "FPM_SOCKET_ADDR should be defined but was empty."
    exit 1
fi

if [ -z "${FPM_STATUS_PATH:-}" ]; then
    echo "FPM_STATUS_PATH should be defined but was empty."
    exit 1
fi

function liveness() {
  local resp
  resp=$(
    REQUEST_METHOD="GET" \
      SCRIPT_NAME="$FPM_STATUS_PATH" \
      SCRIPT_FILENAME="$FPM_STATUS_PATH" \
      cgi-fcgi -bind -connect "$FPM_SOCKET_ADDR"
  )
  echo "$resp"
}

liveness
