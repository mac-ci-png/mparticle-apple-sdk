#!/bin/bash

#
# This script creates pre-built SDK artfacts that will be attached to the GitHub release.
#
# If you add new files here, you need to also add them in release.config.js.
#

# --- Configuration ---

ARTIFACT_DIR="$HOME/artifacts"

# --- Functions ---

function apply_location_patch() {
  git apply ./Scripts/0001-DISABLE-LOCATION.patch
  git add .
  git commit -m "DISABLE LOCATION"
}

function build_carthage_artifact() {
  mkdir -p "$ARTIFACT_DIR"
  rm -rf Carthage
  echo $1 | grep nolocation && apply_location_patch
  echo $1 | grep xcframework || (./Scripts/carthage.sh build --no-skip-current; carthage archive; mv mParticle_Apple_SDK.framework.zip "$ARTIFACT_DIR/$1")
  echo $1 | grep xcframework && (carthage build --no-skip-current --use-xcframeworks; ditto -c -k --sequesterRsrc --keepParent ./Carthage/Build/mParticle_Apple_SDK.xcframework "$ARTIFACT_DIR/$1")
  echo $1 | grep nolocation && git reset --hard HEAD^
}

function build_docs_artifact() {
  ROOT="$(pwd)"
  git clone https://github.com/tomaz/appledoc
  cd appledoc
  sudo sh install-appledoc.sh
  cd "$ROOT"
  appledoc --exit-threshold=2 "./Scripts/AppledocSettings.plist"
  ditto -c -k --sequesterRsrc --keepParent "./Docs/html" "$ARTIFACT_DIR/$1"
}

function move_artifacts() {

  # we can't keep them in currect directory because we manipulate git and
  # they will get wiped out, so this moves them back in when it's safe

  ls "$ARTIFACT_DIR" | xargs -n 1 -J % mv % .
}

# --- Main impl ---

build_carthage_artifact mParticle_Apple_SDK.framework.zip

build_carthage_artifact mParticle_Apple_SDK.framework.nolocation.zip

build_carthage_artifact mParticle_Apple_SDK.xcframework.zip

build_carthage_artifact mParticle_Apple_SDK.xcframework.nolocation.zip

build_docs_artifact generated-docs.zip

move_artifacts