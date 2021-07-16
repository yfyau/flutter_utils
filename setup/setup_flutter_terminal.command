#!/bin/bash
set -e

CURR_PATH="`dirname \"$0\"`"
cd $CURR_PATH

echo "Enter Flutter SDK Path :"
read FLUTTER_PATH

BASH_FILE="$HOME/.bash_profile"
ZSHRC_FILE="$HOME/.zshrc"

echo "export PATH=\$PATH:$FLUTTER_PATH/bin" >> $BASH_FILE
echo "export PATH=\$PATH:$FLUTTER_PATH/bin" >> $ZSHRC_FILE

exit 0