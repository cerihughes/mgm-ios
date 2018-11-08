apiKey=$(sed -n '1p' < Secrets.txt)
secretKey=$(sed -n '2p' < Secrets.txt)

cp $PROJECT_DIR/MusicGeekMonthly/Info.plist $PROJECT_DIR/MusicGeekMonthly/Secret.plist
sed "s/_FABRIC_KEY_/$apiKey/" $PROJECT_DIR/MusicGeekMonthly/Info.plist > $PROJECT_DIR/MusicGeekMonthly/Temp.plist
sed "s/_BUILD_NUMBER_/`git rev-list HEAD --count`/" $PROJECT_DIR/MusicGeekMonthly/Temp.plist > $PROJECT_DIR/MusicGeekMonthly/Secret.plist
rm $PROJECT_DIR/MusicGeekMonthly/Temp.plist
