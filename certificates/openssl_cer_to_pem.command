#!/bin/sh

CURR_PATH="`dirname \"$0\"`"
cd $CURR_PATH

echo "Script Path - $CURR_PATH"

for cer in *.cer;
do 
    echo "Convert file - $cer";
    echo $(openssl x509 -inform der -in "${cer}" -out "${cer%.*}".pem)
done