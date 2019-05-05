#!/bin/bash
set -e

apiKey=$(sed -n '1p' < Secrets.txt)
secretKey=$(sed -n '2p' < Secrets.txt)

cp $PROJECT_DIR/Source/Info.plist $PROJECT_DIR/Source/Secret.plist
sed "s/_FABRIC_KEY_/$apiKey/" $PROJECT_DIR/Source/Info.plist > $PROJECT_DIR/Source/Temp.plist
sed "s/_BUILD_NUMBER_/`git rev-list HEAD --count`/" $PROJECT_DIR/Source/Temp.plist > $PROJECT_DIR/Source/Secret.plist
rm $PROJECT_DIR/Source/Temp.plist
