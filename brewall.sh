#!/bin/bash

debugPath=~/Library/Logs/Homebrew
brewPath=
update=false
upgrade=false
cleanup=false
doctor=false
elapsedTime=
executePath=$(echo $0 | sed "s/\/brewall.sh//g")
simpleLANG=$(cut -f 1 -d '.' <<< $LANG)

cd $executePath

function English() {
    source $executePath/localization/en_US/brewall_en-US.sh
    source $executePath/localization/en_US/install_en-US.sh
    source $executePath/localization/en_US/upgrade_en-US.sh
    source $executePath/localization/en_US/changelog_en-US.sh
}

function Korean() {
    source $executePath/localization/ko_KR/brewall_ko-KR.sh
    source $executePath/localization/ko_KR/install_ko-KR.sh
    source $executePath/localization/ko_KR/upgrade_ko-KR.sh
    source $executePath/localization/ko_KR/changelog_ko-KR.sh
}

if [ "$simpleLANG" == "ko_KR" ]; then
    Korean
elif [ "$simpleLANG" == "en_US" ]; then
    English
else
    echo -e "\033[33mWarning\033[m: $LANG is not supported at this time."
    echo "The default language will be English."
    English
fi

if [ "$1" == "version" ]; then
    echo -e "brewall ($GIT_REVISION $(git rev-parse --short HEAD), $LAST_COMMIT $(git log -1 --date=format:"%Y-%m-%d" --format="%ad"), $(git branch | sed '/* /!d'| sed 's/* //g') $BUILD)"
    echo -e "Copyright (c) 2020-2022 Hyeongmin Kim\n"
    bash --version
    echo ""
    which brew > /dev/null 2>&1
    if [ $? == 0 ]; then
        brew --version
    else
        echo "$ERR_DETECT_BREW"
    fi
    echo ""
    which git > /dev/null 2>&1
    if [ $? == 0 ]; then
        git --version
    else
        echo "$ERR_DETECT_GIT"
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

        "$executePath/tools/changelog.sh" "$cntRevision" "$updatedRevision"
    fi
    exit 0
elif [ "$1" == "remove" ]; then
    if [ -x $executePath/tools/install.sh ]; then
        "$executePath/tools/install.sh" "uninstall" "$2"
    else
        echo -e "$ERR_EXECUTE_UNINSTALLER"
    fi
    exit $?
elif [ x$1 == x ]; then
    echo "" > /dev/null 2>&1
elif [ "$1" == "help" ]; then
    open https://github.com/HyeongminKim/brewall\#usage-brewallsh-command-option 2> /dev/null
    if [ $? != 0 ]; then
        echo "URL: https://github.com/HyeongminKim/brewall#usage-brewallsh-command-option"
    fi
    echo "$SHOW_CMD_USAGE"
    exit 0
else
    echo "$IGNORE_UNKNOWN_CMD_TITLE_FRONT $@ $IGNORE_UNKNOWN_CMD_TITLE_BACK"
    echo "$IGNORE_UNKNOWN_CMD_INFO"
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
            echo -e "$DOWN_SYMBOL_FRONT $result $DOWN_SYMBOL_BACK"
            echo -e "$DOWN_SYMBOL"
        elif [ $previousElapsedTime -lt $currentElapsedTime ]; then
            result=$(($currentElapsedTime-$previousElapsedTime))
            echo -e "$UP_SYMBOL_FRONT $result $UP_SYMBOL_BACK"
        else
            echo "$EQUAL_SYMBOL"
        fi
    else
        echo "$EQUAL_SYMBOL"
    fi
    echo "$elapsedTime" > $debugPath/ElapsedTime.txt

}

function executeExtension() {
    if [ -r ~/Library/Application\ Support/com.greengecko.brewall/extension.csm ]; then
        shasum -a 256 $executePath/tools/extension.sh > $debugPath/extension.csm
        diff ~/Library/Application\ Support/com.greengecko.brewall/extension.csm $debugPath/extension.csm > /dev/null
        if [ $? != 0 ]; then
            extensionVerification
        else
            "$executePath/tools/extension.sh"
        fi
        rm $debugPath/extension.csm
    else
        extensionVerification
    fi

}

function extensionVerification() {
    echo "$CSM_CHECK_EXTENSION $(shasum -a 256 $executePath/tools/extension.sh)"
    while true; do
        echo -n "$CHECK_OPERATION"
        read input
        if [ "$input" == "y" -o "$input" == "Y" ]; then
            shasum -a 256 $executePath/tools/extension.sh > ~/Library/Application\ Support/com.greengecko.brewall/extension.csm
            cp $executePath/tools/extension.sh ~/Library/Application\ Support/com.greengecko.brewall/extension.sh.bak
            "$executePath/tools/extension.sh"
            break
        elif [ "$input" == "n" -o "$input" == "N" ]; then
            echo "$EXECUTE_EXTENSION_ABORT"
            break
        elif [ "$input" == "d" -o "$input" == "D" ]; then
            if [ -r ~/Library/Application\ Support/com.greengecko.brewall/extension.sh.bak ]; then
                cat $executePath/tools/extension.sh > $debugPath/extension.txt
                cat ~/Library/Application\ Support/com.greengecko.brewall/extension.sh.bak > $debugPath/extension_bak.txt
                git diff --no-index $debugPath/extension_bak.txt $debugPath/extension.txt

                rm $debugPath/extension.txt $debugPath/extension_bak.txt
            else
                less $executePath/tools/extension.sh
            fi
        else
            echo "$IGNORE_UNKNOWN_CMD_TITLE_FRONT $input $IGNORE_UNKNOWN_CMD_TITLE_BACK"
        fi
    done
}

startTime=$(date +%s)

ping -c 1 -W 1 -q "www.google.com" &> /dev/null
if [ "$?" != "0" ]; then
    echo -en "$ERR_INT_CNT"
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
            echo -e "$SYN_INT_CNT"
            break
        fi
    done
fi

if [ -x $executePath/tools/install.sh ]; then
    "$executePath/tools/install.sh" "install"
    if [ $? == 3 ]; then
        exit 3
    fi

    if [ $? != 0 ]; then
        rm ~/Library/Application\ Support/com.greengecko.brewall/brewall.lock 2> /dev/null
        exit $?
    fi
else
    echo -e "$ERR_CHK_DPY"
    rm ~/Library/Application\ Support/com.greengecko.brewall/brewall.lock 2> /dev/null
    exit 1
fi

brewPath=$(which brew 2> /dev/null)

if [ -r $debugPath/brewall_initiated.log ]; then
    cat $debugPath/brewall_initiated.log
fi
echo -n "$PREV_TIME" > $debugPath/brewall_initiated.log
echo -e "$START_TIME"

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
    echo -e "$ERR_UPDATE"
    open https://github.com/HyeongminKim/brewall
fi
if [ "$update" = true -o "$upgrade" = true -o "$cleanup" = true -o "$doctor" = true ]; then
    logFiles=$(ls $debugPath |grep brew_ |grep -c debug.log)
    if [ $logFiles == 1 ]; then
        echo -e "$ERR_LOG_SAVED_ONE_TITLE_FRONT $debugPath $ERR_LOG_SAVED_ONE_TITLE_BACK"
        echo "$ERR_LOG_SAVED_ONE_INFO"
    else
        echo -e "$ERR_LOG_SAVED_MANY_TITLE_FRONT $debugPath $ERR_LOG_SAVED_MANY_TITLE_BACK"
        echo "$ERR_LOG_SAVED_MANY_INFO"
    fi
    ls -lh $debugPath | awk '{print $9 " ("$5")"}' |grep brew_ |grep debug.log
    if [ $logFiles == 1 ]; then
        echo "-------------------------"
    else
        echo "--------------------------"
    fi
    echo "$FAILURE_INFO" >> $debugPath/brewall_initiated.log
    if [ -x $executePath/tools/extension.sh ]; then
        executeExtension
        if [ $? != 0 ]; then
            echo -e "$ERR_EXTENSION"
            echo "$FAILURE_INFO" >> $debugPath/brewall_initiated.log
        fi
    else
        echo -e "$EXTENSION_INFO_FRONT $executePath$EXTENSION_INFO_BACK"
    fi
    rm ~/Library/Application\ Support/com.greengecko.brewall/brewall.lock 2> /dev/null
    endTime=$(date +%s)
    echo -n "$TIME_USE"
    calcTime $endTime $startTime
    compareTime
else
    echo -e "$OK_TITLE"
    if [ -x $executePath/tools/extension.sh ]; then
        executeExtension
        if [ $? == 0 ]; then
            echo "$SUCCESS_INFO" >> $debugPath/brewall_initiated.log
            rm ~/Library/Application\ Support/com.greengecko.brewall/brewall.lock 2> /dev/null
            endTime=$(date +%s)
            echo -n "$TIME_USE"
            calcTime $endTime $startTime
            compareTime
        else
            echo -e "$ERR_EXTENSION"
            echo "$FAILURE_INFO" >> $debugPath/brewall_initiated.log
            rm ~/Library/Application\ Support/com.greengecko.brewall/brewall.lock 2> /dev/null
            endTime=$(date +%s)
            echo -n "$TIME_USE"
            calcTime $endTime $startTime
            compareTime
        fi
    else
        echo -e "$EXTENSION_INFO_FRONT $executePath$EXTENSION_INFO_BACK"
        echo "$SUCCESS_INFO" >> $debugPath/brewall_initiated.log
        rm ~/Library/Application\ Support/com.greengecko.brewall/brewall.lock 2> /dev/null
        endTime=$(date +%s)
        echo -n "$TIME_USE"
        calcTime $endTime $startTime
        compareTime
    fi
fi
