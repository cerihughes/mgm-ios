#!/bin/bash
set -e

cp $PROJECT_DIR/Source/Info.plist $PROJECT_DIR/Source/Secret.plist
sed "s/_BUILD_NUMBER_/`git rev-list HEAD --count`/" $PROJECT_DIR/Source/Info.plist > $PROJECT_DIR/Source/Secret.plist
