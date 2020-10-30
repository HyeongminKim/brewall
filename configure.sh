#!/bin/bash

echo "This configure helper require brewall version 1.0.7(1A012) or later."
echo -n "Are you wish continue? (Y/n) > "
read input
if [ $input == "Y" -o $input == "y" -o x$input == x ]; then
    echo "" > /dev/null 2>&1
else 
    echo "User abort this script. "
    exit 1
fi

ls ~/Library/Application\ Support/com.greengecko.brewall > /dev/null 2>&1
if [ $? != 0 ]; then
    mkdir ~/Library/Application\ Support/com.greengecko.brewall
    touch ~/Library/Application\ Support/com.greengecko.brewall/initializationed
fi
ls ~/Library/Application\ Support 2> /dev/null | grep com.greengecko.brewall.initializationed > /dev/null 2>&1
if [ $? == 0 ]; then
    rm ~/Library/Application\ Support/com.greengecko.brewall.initializationed > /dev/null 2>&1
fi
