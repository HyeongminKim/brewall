#!/bin/bash

tempPath=~/Library/Logs/Homebrew
cd $1
last_commit=$(git rev-parse HEAD)
last_version=$2

if [ $LANG == "ko_KR.UTF-8" ]; then
    echo -e "\033[32mbrewall 업데이트중"
else
    echo -e "\033[32mUpdating brewall"
fi
if git pull --rebase --stat origin master; then
    updated_commit=$(git rev-parse HEAD)
    if [ "$updated_commit" = "$last_commit" ]; then
        echo -en "\033[m"
    else
        updated_version=$("$1/brewall.sh" "version" | sed '/brewall/!d'| sed 's/brewall //g')
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[34mbrewall이 성공적으로 업데이트 되었습니다.\033[m"
        else
            echo -e "\033[34mbreall has been updated. \033[m"
        fi
        echo "$last_version → $updated_version"

        #TODO: Classified according to commit comments and show current branch
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[0;1m현재 업데이트 채널\033[m" >> $tempPath/releasenote.txt
        else
            echo -e "\033[0;1mCurrent update channel\033[m" >> $tempPath/releasenote.txt
        fi
        echo -e "\033[0;4m$(git branch | sed '/* /!d'| sed 's/* //g')\033[m\n" >> $tempPath/releasenote.txt

        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[0;1m새로운 기능\033[m" >> $tempPath/releasenote.txt
        else
            echo -e "\033[0;1mNew features\033[m" >> $tempPath/releasenote.txt
        fi
        git log --stat --grep="[NEW]" --color --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updated_commit...$last_commit >> $tempPath/releasenote.txt
        echo ""

        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[0;1m업데이트된 기능\033[m" >> $tempPath/releasenote.txt
        else
            echo -e "\033[0;1mUpdated features\033[m" >> $tempPath/releasenote.txt
        fi
        git log --stat --grep="[UPDATED]" --color --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updated_commit...$last_commit >> $tempPath/releasenote.txt
        echo ""

        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[0;1m삭제된 기능\033[m" >> $tempPath/releasenote.txt
        else
            echo -e "\033[0;1mRemoved features\033[m" >> $tempPath/releasenote.txt
        fi
        git log --stat --grep="[REMOVED]" --color --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updated_commit...$last_commit >> $tempPath/releasenote.txt
        echo ""

        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[0;1m실험중인 기능\033[m" >> $tempPath/releasenote.txt
        else
            echo -e "\033[0;1mTesting features\033[m" >> $tempPath/releasenote.txt
        fi
        git log --stat --grep="[TEST]" --color --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updated_commit...$last_commit >> $tempPath/releasenote.txt
        echo ""

        less -R $tempPath/releasenote.txt
        rm $tempPath/releasenote.txt
    fi
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31m에러가 발생하였습니다. 잠시후 다시 시도하세요?\033[m"
    else
        echo -e "\033[31mThere was an error occured. Try again later?\033[m"
    fi
    exit 1
fi

