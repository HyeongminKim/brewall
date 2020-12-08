#!/bin/bash

cd $1
last_commit=$(git rev-parse HEAD)
echo -e "\033[32mUpdating brewall"
if git pull origin master; then
    if [ "$(git rev-parse HEAD)" = "$last_commit" ]; then
        echo -en "\033[m"
    else
        echo -e "\033[34mbreall has been updated. \033[m"
        git log -p -2 --no-merges
    fi
else
    echo -e "\033[31mThere was an error occured. Try again later.\033[m"
    exit 1
fi

