#!/bin/bash

debugPath=~/Library/Logs/Homebrew
update=false
upgrade=false
cleanup=false
doctor=false
elapsedTime=
executePath=$(echo $0 | sed "s/\/brewall.sh//g")

if [ "$1" == "version" ]; then
    cd $executePath
    echo -e "brewall $(git rev-parse --short HEAD)\nCopyright (c) 2020 Hyeongmin Kim\n"
    bash --version
    echo ""
    brew --version
    echo ""
    git --version
    exit 0
elif [ "$1" == "runtime" ]; then
    if [ -r $debugPath/brewall_initiated.log ]; then
        cat $debugPath/brewall_initiated.log 2> /dev/null
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[31m이전에 brewall을 실행한 적이 없습니다. \033[m"
        else
            echo -e "\033[31mYou have never run brewall before.\033[m"
        fi
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
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "사용법: $0 [옵션]"
        echo "              version: 스크립트 버전 출력"
        echo "              runtime: 이전 brewall 시간 출력"
        echo "               remove: brew 패키지 관리자 제거 (다른 옵션: --dry-run, --purge)"
        echo "                 help: 스크립트 도움말 출력"
    else
        echo "USAGE: $0 [OPTION]"
        echo "              version: Print script version"
        echo "              runtime: Print previous brewall launch time"
        echo "               remove: brew package manager uninstall (other option: --dry-run, --purge)"
        echo "                 help: Print script help"
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
    currenrtElapsedTime=$elapsedTime
    if [ -r $debugPath/ElapsedTime.txt ]; then
        previousElapsedTime=$(cat $debugPath/ElapsedTime.txt 2> /dev/null)
        if [ $previousElapsedTime -gt $currenrtElapsedTime ]; then
            result=$(($previousElapsedTime-$currenrtElapsedTime))
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -e "\033[34m▼ $result 초\033[m"
            else
                echo -e "\033[31m▼ $result sec\033[m"
            fi
        elif [ $previousElapsedTime -lt $currenrtElapsedTime ]; then
            result=$(($currenrtElapsedTime-$previousElapsedTime))
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

if [ -x $executePath/tools/install.sh ]; then
    "$executePath/tools/install.sh" "install"
    if [ $? != 0 ]; then
        exit 1
    fi
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31m의존성 패키지가 제대로 설치되어 있는지 확인할 수 없어 종료합니다. \033[m"
    else
        echo -e "\033[31mExited because dependency package couldn't be verified.\033[m"
    fi
    exit 1
fi

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

ping -c 1 -W 1 -q "www.google.com" &> /dev/null
if [ "$?" != "0" ]; then
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -en "\033[31m인터넷 연결 확인."
    else
        echo -en "\033[31mCheck your internet connection."
    fi
    while true; do
        ping -c 1 -W 1 -q "www.google.com" &> /dev/null
        if [ "$?" != "0" ]; then
            echo -n "."
            sleep 1
        else
            echo "\033[m"
            break
        fi
    done
fi

brew update 2> $debugPath/brew_update_debug.log
if [ "$?" != "0" ]; then
    update=true
    cat $debugPath/brew_update_debug.log
else
    rm $debugPath/brew_update_debug.log
fi
brew upgrade 2> $debugPath/brew_upgrade_debug.log
if [ "$?" != "0" ]; then
    upgrade=true
    cat $debugPath/brew_upgrade_debug.log
else
    rm $debugPath/brew_upgrade_debug.log
fi
brew cleanup -s 2> $debugPath/brew_cleanup_debug.log
if [ "$?" != "0" ]; then
    cleanup=true
    cat $debugPath/brew_cleanup_debug.log
else
    rm $debugPath/brew_cleanup_debug.log
fi
brew doctor 2> $debugPath/brew_doctor_debug.log
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
    echo "https://github.com/HyeongminKim/brewall"
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
    ls $executePath/tools 2> /dev/null | grep extension > /dev/null 2>&1
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
