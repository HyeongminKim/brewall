#!/bin/bash

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
        git show --stat --color --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updated_commit $last_commit |less -R
    fi
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31m에러가 발생하였습니다. 잠시후 다시 시도하세요.\033[m"
    else
        echo -e "\033[31mThere was an error occured. Try again later.\033[m"
    fi
    exit 1
fi

