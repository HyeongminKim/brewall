#!/bin/bash

debugPath=~/Library/Logs/Homebrew
brewPath=
update=false
upgrade=false
cleanup=false
doctor=false
elapsedTime=
executePath=$(echo $0 | sed "s/\/brewall.sh//g")

if [ "$1" == "version" ]; then
    cd $executePath
    echo -e "brewall (git revision $(git rev-parse --short HEAD), last commit $(git log -1 --date=format:"%Y-%m-%d" --format="%ad"))\nCopyright (c) 2020 Hyeongmin Kim\n"
    bash --version
    echo ""
    which brew > /dev/null 2>&1
    if [ $? == 0 ]; then
        brew --version
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo "brew가 설치되어 있지 않거나 감지되지 않았습니다. "
        else
            echo "brew is not installed or not detected."
        fi
    fi
    echo ""
    which git > /dev/null 2>&1
    if [ $? == 0 ]; then
        git --version
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo "git이 설치되어 있지 않거나 감지되지 않았습니다. "
        else
            echo "git is not installed or not detected."
        fi
    fi
    exit 0
elif [ "$1" == "runtime" ]; then
    if [ -r $debugPath/brewall_initiated.log ]; then
        cat $debugPath/brewall_initiated.log 2> /dev/null
    fi
    exit 0
elif [ "$1" == "changelog" ]; then
    if [ -r $debugPath/cntRevision.txt ] && [ -r $debugPath/updatedRevision.txt ]; then
        cntRevision="$(cat $debugPath/cntRevision.txt)"
        updatedRevision="$(cat $debugPath/updatedRevision.txt)"

        "$executePath/tools/changelog.sh" "$executePath" "$cntRevision" "$updatedRevision"
    fi
    exit 0
elif [ "$1" == "remove" ]; then
    if [ -x $executePath/tools/install.sh ]; then
        "$executePath/tools/install.sh" "uninstall" "$2"
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[31m언인스톨러를 실행할 권한이 없습니다. \033[m"
        else
            echo -e "\033[31mCan't run uninstaller, Please change permission.\033[m"
        fi
    fi
    exit $?
elif [ x$1 == x ]; then
    echo "" > /dev/null 2>&1
elif [ "$1" == "help" ]; then
    open https://github.com/HyeongminKim/brewall\#usage-brewallsh-command-option 2> /dev/null
    if [ $? != 0 ]; then
        echo "URL: https://github.com/HyeongminKim/brewall#usage-brewallsh-command-option"
    fi
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "사용법: $0 [명령] [옵션]"
    else
        echo "USAGE: $0 [COMMAND] [OPTION]"
    fi
    exit 0
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "$@ 은 알 수 없는 명령이며 무시됩니다. "
        echo "brewall의 도움말을 보시려면 help 명령을 사용하십시오. "
    else
        echo "Unknown command $@ Skipping."
        echo "If you wonder brewall help, Please use help command. "
    fi
fi

function calcTime() {
    willConvertStartSecond=$1
    willConvertEndSecond=$2
    calculatedElapsedSecond=$(($willConvertStartSecond-$willConvertEndSecond))
    elapsedTime=$calculatedElapsedSecond
    resultCalculatedHour=$(($calculatedElapsedSecond/3600))
    calculatedElapsedSecond=$(($calculatedElapsedSecond%3600))
    resultCalculatedMin=$(($calculatedElapsedSecond/60))
    calculatedElapsedSecond=$(($calculatedElapsedSecond%60))
    resultCalculatedSec=$calculatedElapsedSecond
    echo -n "$resultCalculatedHour:$resultCalculatedMin'$resultCalculatedSec\" "
}

function compareTime() {
    currentElapsedTime=$elapsedTime
    if [ -r $debugPath/ElapsedTime.txt ]; then
        previousElapsedTime=$(cat $debugPath/ElapsedTime.txt 2> /dev/null)
        if [ $previousElapsedTime -gt $currentElapsedTime ]; then
            result=$(($previousElapsedTime-$currentElapsedTime))
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -e "\033[34m▼ $result 초\033[m"
            else
                echo -e "\033[31m▼ $result sec\033[m"
            fi
        elif [ $previousElapsedTime -lt $currentElapsedTime ]; then
            result=$(($currentElapsedTime-$previousElapsedTime))
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -e "\033[31m▲ $result 초\033[m"
            else
                echo -e "\033[32m▲ $result sec\033[m"
            fi
        else
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo "- 0 초"
            else
                echo "- 0 sec"
            fi
        fi
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo "- 0 초"
        else
            echo "- 0 sec"
        fi
    fi
    echo "$elapsedTime" > $debugPath/ElapsedTime.txt

}

startTime=$(date +%s)

ping -c 1 -W 1 -q "www.google.com" &> /dev/null
if [ "$?" != "0" ]; then
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -en "\033[31m인터넷 연결 확인... "
    else
        echo -en "\033[31mCheck your internet connection... "
    fi
    index=0
    spinner='/-\|'
    n=${#spinner}
    echo -n ' '
    while true; do
        ping -c 1 -W 1 -q "www.google.com" &> /dev/null
        if [ "$?" != "0" ]; then
            printf '\b%s' "${spinner:i++%n:1}"
            sleep 1
        else
            printf '\b\b\b\b%s' " "
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -e "\033[32m연결됨\033[m"
            else
                echo -e "\033[32mConnected\033[m"
            fi
            break
        fi
    done
fi

if [ -x $executePath/tools/install.sh ]; then
    "$executePath/tools/install.sh" "install"
    if [ $? != 0 ]; then
        exit $?
    fi
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31m의존성 패키지가 제대로 설치되어 있는지 확인할 수 없어 종료합니다. \033[m"
    else
        echo -e "\033[31mExited because dependency package couldn't be verified.\033[m"
    fi
    exit 1
fi

brewPath=$(which brew 2> /dev/null)

if [ -r $debugPath/brewall_initiated.log ]; then
    cat $debugPath/brewall_initiated.log
fi
if [ $LANG == "ko_KR.UTF-8" ]; then
    echo -n "[33m이전 시간: $(date)[0m " > $debugPath/brewall_initiated.log
    echo -e "\033[32m시작 시간: $(date)\033[m"
else
    echo -n "[33m Previous time: $(date)[0m " > $debugPath/brewall_initiated.log
    echo -e "\033[32mInitiated time: $(date)\033[m"
fi

if [ "$(uname -m)" == "arm64" ]; then
    if [ "$(which brew)" == "/usr/local/bin/brew" ]; then
        arch -x86_64 brew update 2> $debugPath/brew_update_debug.log
    else
        brew update 2> $debugPath/brew_update_debug.log
    fi
else
    brew update 2> $debugPath/brew_update_debug.log
fi
if [ "$?" != "0" ]; then
    update=true
    cat $debugPath/brew_update_debug.log
else
    rm $debugPath/brew_update_debug.log
fi


if [ "$(uname -m)" == "arm64" ]; then
    if [ "$(which brew)" == "/usr/local/bin/brew" ]; then
        arch -x86_64 brew upgrade 2> $debugPath/brew_upgrade_debug.log
    else
        brew upgrade 2> $debugPath/brew_upgrade_debug.log
    fi
else
    brew upgrade 2> $debugPath/brew_upgrade_debug.log
fi
if [ "$?" != "0" ]; then
    upgrade=true
    cat $debugPath/brew_upgrade_debug.log
else
    rm $debugPath/brew_upgrade_debug.log
fi


if [ "$(uname -m)" == "arm64" ]; then
    if [ "$(which brew)" == "/usr/local/bin/brew" ]; then
        arch -x86_64 brew cleanup -s 2> $debugPath/brew_cleanup_debug.log
    else
        brew cleanup -s 2> $debugPath/brew_cleanup_debug.log
    fi
else
    brew cleanup -s 2> $debugPath/brew_cleanup_debug.log
fi
if [ "$?" != "0" ]; then
    cleanup=true
    cat $debugPath/brew_cleanup_debug.log
else
    rm $debugPath/brew_cleanup_debug.log
fi


if [ "$(uname -m)" == "arm64" ]; then
    if [ "$(which brew)" == "/usr/local/bin/brew" ]; then
        arch -x86_64 brew doctor 2> $debugPath/brew_doctor_debug.log
    else
        brew doctor 2> $debugPath/brew_doctor_debug.log
    fi
else
    brew doctor 2> $debugPath/brew_doctor_debug.log
fi
if [ "$?" != "0" ]; then
    doctor=true
    cat $debugPath/brew_doctor_debug.log
else
    rm $debugPath/brew_doctor_debug.log
fi


if [ -x $executePath/tools/upgrade.sh ]; then
    "$executePath/tools/upgrade.sh" "$executePath"
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31m자동 업데이트 도중 에러가 발생하였습니다. 수동으로 진행하여 주세요\033[m"
    else
        echo -e "\033[31mAn error occurred during automatic update. By going manually\033[m"
    fi
    open https://github.com/HyeongminKim/brewall
fi
if [ "$update" = true -o "$upgrade" = true -o "$cleanup" = true -o "$doctor" = true ]; then
    logFiles=$(ls $debugPath |grep brew_ |grep -c debug.log)
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31mbrewall이 실패했거나 경고가 발생하였습니다.\033[m\nbrewall 로그 파일이 \033[0;1m$debugPath\033[m 에 위치해 있습니다. "
        echo "----- brew 로그 목록 -----"
    else
        if [ $logFiles == 1 ]; then
            echo -e "\033[31mbrewall has failed and/or occurred warning.\033[m\nbrewall log file located \033[0;1m$debugPath\033[m"
            echo "----- brew log list -----"
        else
            echo -e "\033[31mbrewall has failed and/or occurred warning.\033[m\nbrewall log files located \033[0;1m$debugPath\033[m"
            echo "----- brew logs list -----"
        fi
    fi
    ls -lh $debugPath | awk '{print $9 " ("$5")"}' |grep brew_ |grep debug.log
    if [ $logFiles == 1 ]; then
        echo "-------------------------"
    else
        echo "--------------------------"
    fi
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "[31m[실패][0m " >> $debugPath/brewall_initiated.log
    else
        echo "[31m[FAILED][0m " >> $debugPath/brewall_initiated.log
    fi
    if [ -x $executePath/tools/extension.sh ]; then
        "$executePath/tools/extension.sh"
        if [ $? != 0 ]; then
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -e "\033[31m익스텐션을 로드하는 도중 에러가 발생하였습니다. \033[m"
                echo "[31m[실패][0m " >> $debugPath/brewall_initiated.log
            else
                echo -e "\033[31mAn error occurred while loading the extension.\033[m"
                echo "[31m[FAILED][0m " >> $debugPath/brewall_initiated.log
            fi
        fi
    fi
    endTime=$(date +%s)
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -n "소비 시간: "
    else
        echo -n "Elapsed Time: "
    fi
    calcTime $endTime $startTime
    compareTime
    exit 1
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[34mbrewall 이 성공하였습니다.\033[m"
    else
        echo -e "\033[34mbrewall has successful.\033[m"
    fi
    if [ -x $executePath/tools/extension.sh ]; then
        "$executePath/tools/extension.sh"
        if [ $? == 0 ]; then
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo "[34m[성공][0m " >> $debugPath/brewall_initiated.log
            else
                echo "[34m[SUCCEED][0m " >> $debugPath/brewall_initiated.log
            fi
            endTime=$(date +%s)
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -n "소비 시간: "
            else
                echo -n "Elapsed Time: "
            fi
            calcTime $endTime $startTime
            compareTime
            exit 0
        else
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -e "\033[31m익스텐션을 로드하는 도중 에러가 발생하였습니다. \033[m"
                echo "[31m[실패][0m " >> $debugPath/brewall_initiated.log
            else
                echo -e "\033[31mAn error occurred while loading the extension.\033[m"
                echo "[31m[FAILED][0m " >> $debugPath/brewall_initiated.log
            fi
            endTime=$(date +%s)
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -n "소비 시간: "
            else
                echo -n "Elapsed Time: "
            fi
            calcTime $endTime $startTime
            compareTime
            exit 1
        fi
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo "[34m[성공][0m " >> $debugPath/brewall_initiated.log
        else
            echo "[34m[SUCCEED][0m " >> $debugPath/brewall_initiated.log
        fi
        endTime=$(date +%s)
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -n "소비 시간: "
        else
            echo -n "Elapsed Time: "
        fi
        calcTime $endTime $startTime
        compareTime
        exit 0
    fi
fi
