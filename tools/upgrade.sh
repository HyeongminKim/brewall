#!/bin/bash

echo "Updating brewall"
cd $1
last_commit=$(git rev-parse HEAD)
if git pull origin master; then
    if [ "$(git rev-parse HEAD)" = "$last_commit" ]; then
        message="brewall already up to date."
    else
        message="breall has been updated. "
    fi
else
    echo -e "\033[31mThere was an error occured. Try again later."
    exit 1
fi

