#!/bin/bash

inited=true
debugPath=~/Library/Logs/Homebrew
update=false
upgrade=false
cleanup=false
doctor=false
version=1.1.2
build=1A022
elapsedTime=

function printInit() {
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo '#################### 설치 가이드 ###################'
        echo '해야할 것: 아래 명령어를 당신의 $SHELL_CONFIG_FILE 에 삽입하여 주십시오 ("#!>", "<!#" 제외). '
        echo '메모: 이 명령어는 zsh에서 테스트 되었습니다. '
        echo ''
        echo '#!> echo 'alias brewall="$CUSTOMPATH/brewall.sh;softwareupdate -l;echo \"\a\""' >> $SHELL_CONFIG_FILE && source $SHELL_CONFIG_FILE; chmod 550 $CUSTOMPATH/brewall.sh; touch ~/Library/Application\ Support/com.greengecko.brewall.initializationed <!#'
        echo ''
        echo 'ex) echo 'alias brewall="~/.etc/brewall.sh;upgrade_oh_my_zsh;softwareupdate -l;echo \"\a\""' >> ~/.zshrc && source ~/.zshrc; chmod 550 ~/.etc/brewall.sh; touch ~/Library/Application\ Support/com.greengecko.brewall.initializationed'
        echo ''
        echo '경고: ">>" 에서 ">"로 수정하지 마십시오. 당신은 $SHELL_CONFIG_FILE의 내용을 영원히 잃게 됩니다. '
        echo '      모든 사용자에게 쓰기 권한을 부여하지 마십시오.  (경로 변경 제외) '
        echo '          그리고 당신의 사용자계정에는 읽기와 실행권한을 부여해야 합니다.  (추천 권한 모드: 550 또는 500)'
        echo ''
        echo '정보: 이 명령어는 당신의 $SHELL_CONFIG_FILE 에"brewall" 별칭을 설정합니다. '
        echo '      이 "brewall" 별칭 설정이 완료되면 upgrade_oh_my_zsh 및 시스템 업데이트도 확인할 수 있습니다. '
        echo '      그리고 이 스크립트는 Homebrew를 업데이트하며 로그를 ~/Library/Logs/Homebrew 에 저장할겁니다.'
        echo '######################################################'
    else
        echo '#################### INSTALL GUIDE ###################'
        echo 'TODO: INSERT this command to your $SHELL_CONFIG_FILE (except "#!>", "<!#"). '
        echo 'NOTE: This command tested on zsh.'
        echo ''
        echo '#!> echo 'alias brewall="$CUSTOMPATH/brewall.sh;softwareupdate -l;echo \"\a\""' >> $SHELL_CONFIG_FILE && source $SHELL_CONFIG_FILE; chmod 550 $CUSTOMPATH/brewall.sh; mkdir ~/Library/Application\ Support/com.greengecko.brewall; touch ~/Library/Application\ Support/com.greengecko.brewall/initializationed <!#'
        echo ''
        echo 'ex) echo 'alias brewall="~/.etc/brewall.sh;upgrade_oh_my_zsh;softwareupdate -l;echo \"\a\""' >> ~/.zshrc && source ~/.zshrc; chmod 550 ~/.etc/brewall.sh; mkdir ~/Library/Application\ Support/com.greengecko.brewall; touch ~/Library/Application\ Support/com.greengecko.brewall/initializationed'
        echo ''
        echo 'WARN: Do not modify ">>" to ">". You will lost your $SHELL_CONFIG_FILE forever.'
        echo '      Do not grant write permission all user account. (except path change) '
        echo '          And you should grant your user account permission read and execute. (Recommend grant mode: 550 or 500)'
        echo ''
        echo 'INFO: This command will set alias "brewall" in your $SHELL_CONFIG_FILE'
        echo '      When "brewall" command entered run this script, upgrade oh_my_zsh, check macos update. '
        echo '      And this script will update brew and save logs to ~/Library/Logs/Homebrew.'
        echo '######################################################'
    fi
}

if [ "$1" == "init" ]; then
    if [ "$inited" == "false" ]; then
        printInit
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo "이미 스크립트가 설정되어 있습니다. "
        else
            echo "You are already configured this script."
        fi
    fi
    exit 0
elif [ "$1" == "version" ]; then
    echo "$version ($build)"
    exit 0
elif [ "$1" == "runtime" ]; then
    cat $debugPath/brewall_initiated.log
    exit 0
elif [ x$1 == x ]; then
    echo "" > /dev/null 2>&1
elif [ "$1" == "safety_guard_override" ]; then
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "경고. 체크섬 확인이 재정의되었으며 이는 안전하지 않습니다. "
    else
        echo "Warning. Checksum check had overrided which was unsafe. "
    fi
elif [ "$1" == "help" ]; then
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "사용법: $0 [옵션]"
        echo "                 init: 스크립트 초기 설정"
        echo "              version: 스크립트 버전 출력"
        echo "              runtime: 이전 brewall 시간 출력"
        echo "safety_guard_override: 체크섬 확인 비활성화 (권장하지 않음)"
        echo "                 help: 스크립트 도움말 출력"
    else
        echo "USAGE: $0 [OPTION]"
        echo "                 init: Initial set script"
        echo "              version: Print script version"
        echo "              runtime: Print previous brewall launch time."
        echo "safety_guard_override: Disable checksum check (Not recommend)"
        echo "                 help: Print script help"
    fi
    exit 0
else
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "$1 은 알 수 없는 명령이며 무시됩니다. "
        echo "brewall의 도움말을 보시려면 help 명령을 사용하십시오. "
    else
        echo "Unknown command $1 Skipping."
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
    inited=false
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "  경고: \"init\"을 추가하여 이 스크립트를 더 빠르게 실행해 보십시오. "
        echo "사용법: ./brewall.sh init"
        echo "  정보: 이 옵션은 설치 가이드를 프린트할 것입니다. "
    else
        echo " WARN: Please add \"init\" option to run faster this script."
        echo "USAGE: ./brewall.sh init"
        echo " INFO: This option will print install guide."
    fi
    which brew > /dev/null 2>&1
    if [ $? != 0 ]; then
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo "이 brewall 스크립트는 Homebrew 패키지 관리자를 더 사용하기 쉽도록 하는 도구이며 Homebrew가 필수적으로 필요합니다. "
            echo -e "\033[0;1mhttps://brew.sh/index_ko\033[m 이 사이트에 들어가서 Homebrew를 설치하는 것을 도움받거나"
            echo "아니면 아래 명령어를 쉘에 붙여넣으세요. (이 스크립트는 무엇을 할지 설명하고 실행하기 전 잠시 대기합니다. )"
        else
            echo "This brewall script require Homebrew. Because extend of Homebrew tools."
            echo -e "Please enter this site \033[0;1mhttps://brew.sh\033[m and support while install Homebrew or "
            echo "Below paste command in the shell. (This script explains what it will do and then pauses before it does it. )"
        fi
        echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
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

ls ~/Library/Application\ Support/com.greengecko.brewall 2> /dev/null | grep $version > /dev/null 2>&1
if [ $? != 0 ]; then
    rm ~/Library/Application\ Support/com.greengecko.brewall/*.csm 2> /dev/null
    shasum -a 256 $0 > ~/Library/Application\ Support/com.greengecko.brewall/$version.csm 2> /dev/null
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -n "현재 스크립트 체크섬: "
    else
        echo -n "Current script checksum: "
    fi
    cat ~/Library/Application\ Support/com.greengecko.brewall/$version.csm 2> /dev/null
    rm $debugPath/$version.csm 2> /dev/null
elif [ "$1" != "safety_guard_override" ]; then
    shasum -a 256 $0 > $debugPath/$version.csm
    diff ~/Library/Application\ Support/com.greengecko.brewall/$version.csm $debugPath/$version.csm > /dev/null 2>&1
    if [ $? == 0 ]; then
        echo "" > /dev/null 2>&1
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -n "저장된 스크립트 체크섬: "
            cat ~/Library/Application\ Support/com.greengecko.brewall/$version.csm 2> /dev/null
            echo -n "현재 스크립트 체크섬: "
            cat $debugPath/$version.csm
            echo "스크립트 파일이 악의적 목적으로 변조되었을 가능성이 있어 중단되었습니다. "
        else
            echo -n "Saved script checksum: "
            cat ~/Library/Application\ Support/com.greengecko.brewall/$version.csm 2> /dev/null
            echo -n "Current script checksum: "
            cat $debugPath/$version.csm
            echo "Unauthorized edited script who changes by hacker. Aborting."
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
    rm $debugPath/$version.csm 2> /dev/null
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
    logsize=$(ls -lh $debugPath/brew_update_debug.log | awk '{print $5}')
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "제거중: $debugPath/brew_update_debug.log... ($logsize)"
    else
        echo "Removing: $debugPath/brew_update_debug.log... ($logsize)"
    fi
    rm $debugPath/brew_update_debug.log
fi
brew upgrade 2> $debugPath/brew_upgrade_debug.log
if [ "$?" != "0" ]; then
    upgrade=true
    cat $debugPath/brew_upgrade_debug.log
else
    logsize=$(ls -lh $debugPath/brew_upgrade_debug.log | awk '{print $5}')
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "제거중: $debugPath/brew_upgrade_debug.log... ($logsize)"
    else
        echo "Removing: $debugPath/brew_upgrade_debug.log... ($logsize)"
    fi
    rm $debugPath/brew_upgrade_debug.log
fi
brew cleanup -s 2> $debugPath/brew_cleanup_debug.log
if [ "$?" != "0" ]; then
    cleanup=true
    cat $debugPath/brew_cleanup_debug.log
else
    logsize=$(ls -lh $debugPath/brew_cleanup_debug.log | awk '{print $5}')
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "제거중: $debugPath/brew_cleanup_debug.log... ($logsize)"
    else
        echo "Removing: $debugPath/brew_cleanup_debug.log... ($logsize)"
    fi
    rm $debugPath/brew_cleanup_debug.log
fi
brew doctor 2> $debugPath/brew_doctor_debug.log
if [ "$?" != "0" ]; then
    doctor=true
    cat $debugPath/brew_doctor_debug.log
else
    logsize=$(ls -lh $debugPath/brew_doctor_debug.log | awk '{print $5}')
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo "제거중: $debugPath/brew_doctor_debug.log... ($logsize)"
    else
        echo "Removing: $debugPath/brew_doctor_debug.log... ($logsize)"
    fi
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
    ls $debugPath |grep brew_ |grep debug.log
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
