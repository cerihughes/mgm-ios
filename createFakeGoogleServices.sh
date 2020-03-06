#!/bin/bash
set -e

echo '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>API_KEY</key><string>1</string><key>PLIST_VERSION</key><string>1</string><key>GCM_SENDER_ID</key><string>111111111111</string><key>BUNDLE_ID</key><string>uk.co.cerihughes.Music-Geek-Monthly</string><key>GOOGLE_APP_ID</key><string>1:111111111111:ios:1111111111111111</string></dict></plist>' > Source/GoogleService-Info.plist