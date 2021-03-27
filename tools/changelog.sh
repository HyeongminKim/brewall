#!/bin/bash

cd $1

beforeCommit="$2"
updatedCommit="$3"
cntBranch=$(git branch | sed '/* /!d'| sed 's/* //g')
releasePath=~/Library/Logs/Homebrew

if [ "$beforeCommit" == "$updatedCommit" ]; then
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31m동일한 리비전을 비교하는 중입니다. \033[m"
    else
        echo -e "\033[31mComparing the same revision. \033[m"
    fi
    exit 1
fi

if [ $LANG == "ko_KR.UTF-8" ]; then
    echo -e "\033[0;1m업데이트 채널\033[m" > $releasePath/releasenote.txt
else
    echo -e "\033[0;1mUpdate channel\033[m" > $releasePath/releasenote.txt
fi
echo -e "\033[0;4m$cntBranch\033[m\n" >> $releasePath/releasenote.txt

if [ -z "$(git log -1 --grep="ADD" --no-merges --pretty=format:"%h" $updatedCommit...$beforeCommit)" ]; then
    echo "" > /dev/null
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[0;1m새로운 기능\033[m" >> $releasePath/releasenote.txt
    else
        echo -e "\033[0;1mNew features\033[m" >> $releasePath/releasenote.txt
    fi
    git log --stat --color --grep="ADD" --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updatedCommit...$beforeCommit >> $releasePath/releasenote.txt
    echo "" >> $releasePath/releasenote.txt
fi

if [ -z "$(git log -1 --grep="UPDATE" --no-merges --pretty=format:"%h" $updatedCommit...$beforeCommit)" ]; then
    echo "" > /dev/null
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[0;1m업데이트된 기능\033[m" >> $releasePath/releasenote.txt
    else
        echo -e "\033[0;1mUpdated features\033[m" >> $releasePath/releasenote.txt
    fi
    git log --stat --color --grep="UPDATE" --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updatedCommit...$beforeCommit >> $releasePath/releasenote.txt
    echo "" >> $releasePath/releasenote.txt
fi

if [ -z "$(git log -1 --grep="DELETE" --no-merges --pretty=format:"%h" $updatedCommit...$beforeCommit)" ]; then
    echo "" > /dev/null
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[0;1m삭제된 기능\033[m" >> $releasePath/releasenote.txt
    else
        echo -e "\033[0;1mRemoved features\033[m" >> $releasePath/releasenote.txt
    fi
    git log --stat --color --grep="DELETE" --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updatedCommit...$beforeCommit >> $releasePath/releasenote.txt
    echo "" >> $releasePath/releasenote.txt
fi

if [ "$(git branch | sed '/* /!d'| sed 's/* //g')" == "nightly" ]; then
    if [ -z "$(git log -1 --grep="TEST" --no-merges --pretty=format:"%h" $updatedCommit...$beforeCommit)" ]; then
        echo "" > /dev/null
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[0;1m실험중인 기능\033[m" >> $releasePath/releasenote.txt
        else
            echo -e "\033[0;1mTesting features\033[m" >> $releasePath/releasenote.txt
        fi
        git log --stat --color --grep="TEST" --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updatedCommit...$beforeCommit >> $releasePath/releasenote.txt
        echo "" >> $releasePath/releasenote.txt
    fi
fi

cat $releasePath/releasenote.txt

rm $releasePath/releasenote.txt