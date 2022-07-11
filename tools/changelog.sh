#!/bin/bash

if [ "$IS_DEBUG" != "TRUE" ]; then
    beforeCommit="$1"
    updatedCommit="$2"
else
    beforeCommit="$(git rev-parse HEAD^)"
    updatedCommit="$(git rev-parse HEAD)"
fi
executePath=$(echo $0 | sed "s/\/tools\/changelog.sh//g")
cntBranch=$(git branch | sed '/* /!d'| sed 's/* //g')
releasePath=~/Library/Logs/Homebrew

cd $executePath

function releaseCommitFormatter() {
    git log --stat --color --grep="$1" --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updatedCommit...$beforeCommit >> $releasePath/releasenote.txt
}

if [ "$beforeCommit" == "$updatedCommit" ]; then
    echo -e "$ERR_EQUAL_REVISION"
    exit 1
fi

echo -e "$UPDATE_CHANNEL" > $releasePath/releasenote.txt
echo -e "\033[0;4m$cntBranch\033[m\n" >> $releasePath/releasenote.txt
if [ "$cntBranch" == "nightly" ]; then
    echo -e "$WARN_NIGHTLY_CHANNEL" > $releasePath/releasenote.txt
fi

if ! [ -z "$(git log -1 --grep="ADD" --no-merges --pretty=format:"%h" $updatedCommit...$beforeCommit)" ]; then
    echo -e "$ADD_TITLE" >> $releasePath/releasenote.txt
    releaseCommitFormatter "ADD"
    echo "" >> $releasePath/releasenote.txt
fi

if ! [ -z "$(git log -1 --grep="UPDATE" --no-merges --pretty=format:"%h" $updatedCommit...$beforeCommit)" ]; then
    echo -e "$UPDATE_TITLE" >> $releasePath/releasenote.txt
    releaseCommitFormatter "UPDATE"
    echo "" >> $releasePath/releasenote.txt
fi

if ! [ -z "$(git log -1 --grep="DELETE" --no-merges --pretty=format:"%h" $updatedCommit...$beforeCommit)" ]; then
    echo -e "$DELETE_TITLE" >> $releasePath/releasenote.txt
    releaseCommitFormatter "DELETE"
    echo "" >> $releasePath/releasenote.txt
fi

if [ "$(git branch | sed '/* /!d'| sed 's/* //g')" == "nightly" ]; then
    if ! [ -z "$(git log -1 --grep="TEST" --no-merges --pretty=format:"%h" $updatedCommit...$beforeCommit)" ]; then
        echo -e "$TEST_TITLE" >> $releasePath/releasenote.txt
        releaseCommitFormatter "TEST"
        echo "" >> $releasePath/releasenote.txt
    fi
fi

cat $releasePath/releasenote.txt
rm $releasePath/releasenote.txt
