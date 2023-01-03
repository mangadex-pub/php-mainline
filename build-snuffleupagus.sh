#!/usr/bin/env bash

set -euo pipefail

echo "Building snuffleupagus (git ref: $2) in: $1"
BUILD_DIR="$1"
GITREF="$2"

function clone_snuffleupagus() {
  local TARGET_DIR="$1"
  local GITREF="$2"

  git clone -b master https://github.com/jvoisin/snuffleupagus.git "$TARGET_DIR"
  git -C /snuffleupagus reset --hard "$GITREF"
}

function build() {
  phpize
  ./configure --enable-snuffleupagus

  make -j"$(nproc)"

  export NO_INTERACTION=true
  if ! make -j"$(nproc)" test; then
    echo "Some tests failed! (exit code: $?)"
    exit 1
  fi
}

clone_snuffleupagus "$BUILD_DIR" "$GITREF"
cd "$BUILD_DIR/src"
build
