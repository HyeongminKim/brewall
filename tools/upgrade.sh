#!/bin/bash

cd $1
last_commit=$(git rev-parse HEAD)
last_version=$(git rev-parse --short HEAD)

function showCommit() {
    releasePath=~/Library/Logs/Homebrew
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[0;1m업데이트 채널\033[m" >> $releasePath/releasenote.txt
    else
        echo -e "\033[0;1mUpdate channel\033[m" >> $releasePath/releasenote.txt
    fi
    if [ $(git branch | sed '/* /!d'| sed 's/* //g') == "master" ]; then
        echo -e "\033[0;4mstable\033[m\n" >> $releasePath/releasenote.txt
    else
        echo -e "\033[0;4m$(git branch | sed '/* /!d'| sed 's/* //g')\033[m\n" >> $releasePath/releasenote.txt
    fi

    if [ -n $(git log --grep="ADD" --no-merges --pretty=format:"%h" $updated_commit...$last_commit) ]; then
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[0;1m새로운 기능\033[m" >> $releasePath/releasenote.txt
        else
            echo -e "\033[0;1mNew features\033[m" >> $releasePath/releasenote.txt
        fi
        git log --stat --color --grep="ADD" --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updated_commit...$last_commit >> $releasePath/releasenote.txt
        echo "" >> $releasePath/releasenote.txt
    fi

    if [ -n $(git log --grep="UPDATE" --no-merges --pretty=format:"%h" $updated_commit...$last_commit) ]; then
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[0;1m업데이트된 기능\033[m" >> $releasePath/releasenote.txt
        else
            echo -e "\033[0;1mUpdated features\033[m" >> $releasePath/releasenote.txt
        fi
        git log --stat --color --grep="UPDATE" --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updated_commit...$last_commit >> $releasePath/releasenote.txt
        echo "" >> $releasePath/releasenote.txt
    fi

    if [ -n $(git log --grep="DELETE" --no-merges --pretty=format:"%h" $updated_commit...$last_commit) ]; then
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[0;1m삭제된 기능\033[m" >> $releasePath/releasenote.txt
        else
            echo -e "\033[0;1mRemoved features\033[m" >> $releasePath/releasenote.txt
        fi
        git log --stat --color --grep="DELETE" --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updated_commit...$last_commit >> $releasePath/releasenote.txt
        echo "" >> $releasePath/releasenote.txt
    fi

    if [ "$(git branch | sed '/* /!d'| sed 's/* //g')" == "nightly" ]; then
        if [ -n $(git log --grep="TEST" --no-merges --pretty=format:"%h" $updated_commit...$last_commit) ]; then
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -e "\033[0;1m실험중인 기능\033[m" >> $releasePath/releasenote.txt
            else
                echo -e "\033[0;1mTesting features\033[m" >> $releasePath/releasenote.txt
            fi
            git log --stat --color --grep="TEST" --no-merges --pretty=format:"%C(magenta)%h%Creset - %C(cyan)%an%Creset [%C(red)%ar%Creset]: %C(green)%s%Creset" $updated_commit...$last_commit >> $releasePath/releasenote.txt
            echo "" >> $releasePath/releasenote.txt
        fi
    fi

    less -R $releasePath/releasenote.txt
    rm $releasePath/releasenote.txt
}

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
        updated_version=$(git rev-parse --short HEAD)
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[34mbrewall이 성공적으로 업데이트 되었습니다.\033[m"
        else
            echo -e "\033[34mbreall has been updated. \033[m"
        fi
        echo "$last_version → $updated_version"
        showCommit
    fi
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31m에러가 발생하였습니다. 잠시후 다시 시도하시겠습니까?\033[m"
    else
        echo -e "\033[31mThere was an error occured. Try again later?\033[m"
    fi
    exit 1
fi

