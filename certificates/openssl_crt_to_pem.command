#!/bin/sh

CURR_PATH="`dirname \"$0\"`"
cd $CURR_PATH

echo "Script Path - $CURR_PATH"

for crt in *.crt;
do 
    echo "Convert file - $crt";
    echo $(openssl x509 -in "${crt}" -out "${crt%.*}".pem)
done