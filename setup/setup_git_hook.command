#!/bin/bash
set -e

CURR_PATH="`dirname \"$0\"`"
cd $CURR_PATH

cp git/hooks/* ../.git/hooks/

exit 0