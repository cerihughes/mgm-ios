apiKey=$(sed -n '1p' < Secrets.txt)
secretKey=$(sed -n '2p' < Secrets.txt)

"${PROJECT_DIR}/Frameworks/Fabric.framework/run" $apiKey $secretKey
