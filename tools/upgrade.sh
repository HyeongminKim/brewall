#!/bin/bash

cd $1
last_commit=$(git rev-parse HEAD)
if [ $LANG == "ko_KR.UTF-8" ]; then
    echo -e "\033[32mbrewall 업데이트중\033[m"
else
    echo -e "\033[32mUpdating brewall"
fi
if git pull --rebase --stat origin master; then
    if [ "$(git rev-parse HEAD)" = "$last_commit" ]; then
        echo -en "\033[m"
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[34mbrewall이 성공적으로 업데이트 되었습니다.\033[m"
        else
            echo -e "\033[34mbreall has been updated. \033[m"
        fi
        git show --stat --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $(git rev-parse HEAD) $last_commit
    fi
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31m에러가 발생하였습니다. 잠시후 다시 시도하세요.\033[m"
    else
        echo -e "\033[31mThere was an error occured. Try again later.\033[m"
    fi
    exit 1
fi

