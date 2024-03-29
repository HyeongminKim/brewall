#!/bin/bash

last_commit=$(git rev-parse HEAD)
last_version=$(git rev-parse --short HEAD)
executePath=$(echo $0 | sed "s/\/tools\/upgrade.sh//g")
cntBranch=$(git branch --show-current)
dirCreated=false

cd $executePath

function showCommit() {
    releasePath=~/Library/Logs/Homebrew
    if [ ! -d $releasePath ]; then
        mkdir ~/Library/Logs/Homebrew
        dirCreated=true
    fi
    "$executePath/tools/changelog.sh" "$1" "$2"

    echo $1 > $releasePath/cntRevision.txt
    echo $2 > $releasePath/updatedRevision.txt
}

function donation() {
    donateLink="https://www.paypal.com/paypalme/hmDonate"

    echo -e "$DONATE_PAYPAL_FRONT$donateLink$DONATE_PAYPAL_BACK"
}

echo -e "$NOW_UPDATE"
if git pull --rebase --stat origin $cntBranch; then
    updated_commit=$(git rev-parse HEAD)
    if [ "$updated_commit" = "$last_commit" ]; then
        echo -e "$UP_TO_DATE"
        donation
        exit 0
    else
        updated_version=$(git rev-parse --short HEAD)
        showCommit "$last_commit" "$updated_commit"
        echo -e "$SUCCESS_UPDATE"
        if [ $dirCreated == false ]; then
            echo -e "$CHANGELOG_UPDATE"
        fi
        echo "$last_version → $updated_version"
        donation
        if [ $dirCreated == true ]; then
            rm -rf ~/Library/Logs/Homebrew
        elif [ "$cntBranch" == "nightly" ]; then
            echo -e "$WARN_NIGHTLY_CHANNEL"
            if [ "$IS_DEBUG" != "TRUE" ]; then
                echo -n "$SUGGEST_CHANGE_CHANNEL"
                read n
                if ! [ "$n" == "n" -o "$n" == "N" ]; then
                    git remote update
                    git checkout -t origin/master
                fi
            fi
        fi
        exit 2
    fi
else
    echo -e "$ERR_UPDATE"
    exit 1
fi

