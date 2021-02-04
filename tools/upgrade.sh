#!/bin/bash

cd $1
last_commit=$(git rev-parse HEAD)
last_version=$(git rev-parse --short HEAD)
dirCreated=false
cntBranch=$(git branch | sed '/* /!d'| sed 's/* //g')
executePath=$(echo $0 | sed "s/\/tools\/upgrade.sh//g")

function showCommit() {
    releasePath=~/Library/Logs/Homebrew
    if [ -d $releasePath ]; then
        echo "" > /dev/null
    else
        mkdir ~/Library/Logs/Homebrew
        dirCreated=true
    fi
    "$executePath/tools/extension.sh" "$executePath" "$1" "$2"

    echo $1 > $releasePath/cntRevision.txt
    echo $2 > $releasePath/updatedRevision.txt
}

function donation() {
    donateLink="https://www.paypal.com/paypalme/hmDonate"

    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "이 프로젝트에 기부하시고 싶나요? 페이팔에서 기부: \033[4;34m$donateLink\033[m"
    else
        echo -e "Would you like to donate to this project? Donate from PayPal: \033[4;34m$donateLink\033[m"
    fi
}

if [ $LANG == "ko_KR.UTF-8" ]; then
    echo -e "\033[32mbrewall 업데이트중"
else
    echo -e "\033[32mUpdating brewall"
fi
if git pull --rebase --stat origin $cntBranch; then
    updated_commit=$(git rev-parse HEAD)
    if [ "$updated_commit" = "$last_commit" ]; then
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[34mbrewall은 이미 최신 버전입니다.\033[m"
        else
            echo -e "\033[34mbrewall is already up to date.\033[m"
        fi
        donation
        exit 0
    else
        updated_version=$(git rev-parse --short HEAD)
        showCommit "$last_commit" "$updated_commit"
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[34mbrewall이 성공적으로 업데이트 되었습니다.\033[m"
            if [ $dirCreated == false ]; then
                echo -e "release note를 다시 보시려면 \033[0;1m$1/brewall.sh changelog\033[m 명령을 사용하십시오."
            fi
        else
            echo -e "\033[34mbrewall has been updated. \033[m"
            if [ $dirCreated == false ]; then
                echo -e "You can see the release note again with \033[0;1m$1/brewall.sh changelog\033[m command."
            fi
        fi
        echo "$last_version → $updated_version"
        donation
        if [ $dirCreated == true ]; then
            rm -rf ~/Library/Logs/Homebrew
        fi
        exit 2
    fi
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31m에러가 발생하였습니다. 잠시후 다시 시도하시겠습니까?\033[m"
    else
        echo -e "\033[31mThere was an error occurred. Try again later?\033[m"
    fi
    exit 1
fi

