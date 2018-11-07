apiKey=$(sed -n '1p' < Secrets.txt)
secretKey=$(sed -n '2p' < Secrets.txt)

sed "s/<INVALID>/$apiKey/" $PROJECT_DIR/MusicGeekMonthly/Info.plist > $PROJECT_DIR/MusicGeekMonthly/Secret.plist
