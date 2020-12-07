#!/bin/bash

debugPath=~/Library/Logs/Homebrew
update=false
upgrade=false
cleanup=false
doctor=false
version=1.1.4
build=1A028
elapsedTime=

if [ "$1" == "version" ]; then
    echo "$version ($build)"
    exit 0
elif [ "$1" == "runtime" ]; then
    cat $debugPath/brewall_initiated.log
    exit 0
elif [ x$1 == x ]; then
    echo "" > /dev/null 2>&1
elif [ "$1" == "help" ]; then
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "사용법: $0 [옵션]"
        echo "              version: 스크립트 버전 출력"
        echo "              runtime: 이전 brewall 시간 출력"
        echo "                 help: 스크립트 도움말 출력"
    else
        echo "USAGE: $0 [OPTION]"
        echo "              version: Print script version"
        echo "              runtime: Print previous brewall launch time."
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
    cat $debugPath/ElapsedTime.txt > /dev/null 2>&1
    if [ "$?" == "0" ]; then
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
ls ~/Library/Application\ Support/com.greengecko.brewall 2>/dev/null | grep initializationed > /dev/null 2>&1
if [ "$?" != "0" ]; then
    mkdir ~/Library/Application\ Support/com.greengecko.brewall
    touch ~/Library/Application\ Support/com.greengecko.brewall/initializationed
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "brewall 설정 폴더를 생성하였습니다. 설정 폴더는 \033[0;1m~/Library/Application\ Support/com.greengecko.brewall\033[m에 위치할 것입니다. "
    else
        echo -e "brewall config folder created. This config folder path is \033[0;1m~/Library/Application\ Support/com.greengecko.brewall\033[m"
    fi
fi

ls $debugPath > /dev/null 2>&1
if [ "$?" != "0" ]; then
    mkdir ~/Library/Logs/Homebrew
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "brewall 로그 폴더를 생성하였습니다. 모든 로그 파일들은 \033[0;1m$debugPath\033[m에 위치할 것입니다. "
    else
        echo -e "brewall log folder created. All logs file are located in \033[0;1m$debugPath\033[m"
    fi
fi

which brew > /dev/null 2>&1
if [ $? != 0 ]; then
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "이 brewall 스크립트는 Homebrew 패키지 관리자를 더 사용하기 쉽도록 하는 도구이며 Homebrew가 필수적으로 필요합니다. "
        echo -e "\033[0;1mhttps://brew.sh/index_ko\033[m 이 사이트에 들어가서 Homebrew를 수동으로 설치하거나"
        echo "아니면 지금 한번에 설치할 수 있습니다. (제 3자 스크립트를 실행하며 무엇을 할지 설명하고 잠시 대기합니다. )"

        echo -e "\033[0;1mmacOS 요구사항\033[m"
        echo "64비트 인텔 CPU"
        echo "10.13 이상 권장"
        echo "Xcode 와/또는 xcode-select 필요"

        echo -n "설치하시겠습니까? (Y/n) > "
        read n
        if [ "$n" == "n" -o "$n" == "N" ]; then
            echo "설취를 취소하였습니다. 필수 패키지를 로드할 수 없으므로 종료합니다. "
            exit 1
        fi
    else
        echo "This brewall script require Homebrew. Because extend of Homebrew tools."
        echo -e "Please enter this site \033[0;1mhttps://brew.sh\033[m and manual install Homebrew or "
        echo "Install now on this script. (Execute Third party script and explains what it will do and then pauses before it does it. )"

        echo -e "\033[0;1mmacOS Requirements\033[m"
        echo "64bit Intel CPU"
        echo "10.13 or higher recommand"
        echo "Xcode compiler and/or xcode-select require"

        echo -n "Install Homebrew now? (Y/n) > "
        read n
        if [ "$n" == "n" -o "$n" == "N" ]; then
            echo "Installation aborted. Can not load require package, terminating."
            exit 1
        fi
    fi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

ls $debugPath 2> /dev/null |grep brewall_initiated > /dev/null 2>&1
if [ $? == 0 ]; then
    cat $debugPath/brewall_initiated.log
fi
if [ $LANG == "ko_KR.UTF-8" ]; then
    echo -n "[33m이전 시간: $(date)[0m " > $debugPath/brewall_initiated.log
    echo -e "\033[32m시작 시간: $(date)\033[m"
else
    echo -n "[33m Previous time: $(date)[0m " > $debugPath/brewall_initiated.log
    echo -e "\033[32mInitiated time: $(date)\033[m"
fi

while true; do
    ping -c 1 -W 1 -q "www.google.com" &> /dev/null
    if [ "$?" != "0" ]; then
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "\033[31m인터넷 연결 확인\033[m"
        else
            echo -e "\033[31mCheck your internet connection.\033[m"
        fi
        sleep 1
    else
        break
    fi
done

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
    ls /usr/local/Cellar/macvim/ > /dev/null 2>&1
    if [ "$?" == "0" ]; then
        macvimPath=$(find /usr/local/Cellar/macvim/ -name "MacVim.app")
        if [ "$macvimPath" != "" ]; then
            ln -sF $macvimPath ~/Applications/
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
                echo -e "\033[31mMacVim.app 바로가기를 생성하는데 실패하였습니다. \033[m"
                echo "[31m[실패][0m " >> $debugPath/brewall_initiated.log
            else
                echo -e "\033[31mFailure making MacVim.app alias.\033[m"
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
