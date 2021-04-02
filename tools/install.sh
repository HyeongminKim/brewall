#!/bin/bash

debug=$2
debugPath=~/Library/Logs/Homebrew
executePath=$(echo $0 | sed "s/\/tools\/install.sh//g")
versionChecked=false

if [ "$(uname -s)" != "Darwin" ]; then
    echo -e "$ERR_OS"
    exit 1
fi

xcode-select --print-path > /dev/null 2>&1
if [ $? != 0 ]; then
    xcode-select --install
    echo -e "$INFO_XCS"
    exit 2
fi

function checkVersion() {
    if [ $versionChecked == true ]; then
        return
    fi
    versionChecked=true
    "$executePath/tools/upgrade.sh" "$executePath"
    if [ $? == 0 ]; then
        return
    elif [ $? == 1 ]; then
        exit 1
    else
        echo -e "$APY_RST"
        exit 2
    fi
}

if [ "$1" == "install" ]; then
    ls ~/Library/Application\ Support/com.greengecko.brewall 2>/dev/null | grep initializationed > /dev/null 2>&1
    if [ $? != 0 ]; then
        checkVersion
        curl -fsSkL https://raw.githubusercontent.com/HyeongminKim/brewall/master/LICENSE
        echo -en "$ACT_KEY"
        if [ $debug != true ]; then
            read n
            if [ "$n" == "N" -o "$n" == "n" ]; then
                echo "$DIS_KEY"
                exit 1
            fi
        fi

        mkdir ~/Library/Application\ Support/com.greengecko.brewall
        touch ~/Library/Application\ Support/com.greengecko.brewall/initializationed
        echo -e "$CONF_DIR_MKDIR"
    fi

    if [ -d $debugPath ]; then
        echo "" > /dev/null
    else
        mkdir ~/Library/Logs/Homebrew
        echo -e "$LOG_DIR_MKDIR_FRONT $debugPath $LOG_DIR_MKDIR_BACK"
    fi

    which brew > /dev/null 2>&1
    if [ $? != 0 ]; then
        checkVersion
            echo "$INFO_REQ_BREW"

            echo -e "$SYS_STATUS_TITLE"
            echo "CPU: $(sysctl -n machdep.cpu.brand_string)"
            echo "$(sw_vers -productName) $(sw_vers -productVersion)"

            echo -e "$HOME_REQ_TITLE"
            echo -e "$HOME_REQ_CPU"
            echo "$HOME_REQ_OS"
            echo -e "$HOME_REQ_DEV"

            echo -e "$TIGER_REQ_TITLE"
            echo "$TIGER_REQ_CPU"
            echo -e "$TIGER_REQ_OS"
        if [ $(sw_vers -productVersion) == 10.[45].* ]; then
            echo ""
            curl -fsSkL https://raw.githubusercontent.com/mistydemeo/tigerbrew/master/LICENSE.txt
            echo -e "$TIGER_INSTALL_GUIDE"
            echo -e "$TIGER_INSTALL_INFO_1"
            echo "$TIGER_INSTALL_INFO_2"
            echo "$TIGER_INSTALL_INFO_3"
            echo -n "$TIGER_INSTALL_CHK"
            if [ $debug != true ]; then
                read n
                if [ "$n" == "n" -o "$n" == "N" ]; then
                    echo "$ABT_INSTALL"
                    exit 1
                fi
            fi
            ruby -e "$(curl -fsSkL raw.github.com/mistydemeo/tigerbrew/go/install)"
        else
            echo ""
            curl -fsSkL https://raw.githubusercontent.com/Homebrew/brew/master/LICENSE.txt
            echo -e "$HOME_INSTALL_TITLE"
            echo -e "$HOME_INSTALL_INFO_1"
            echo "$HOME_INSTALL_INFO_2"
            echo "$HOME_INSTALL_INFO_3"
            echo -n "$HOME_INSTALL_CHK"
            if [ $debug != true ]; then
                read n
                if [ "$n" == "n" -o "$n" == "N" ]; then
                    echo "$ABT_INSTALL"
                    exit 1
                fi
            fi
            if [ "$(uname -m)" == "arm64" ]; then
                echo -n "$HOME_INSTALL_ARM"
                if [ $debug != true ]; then
                    read n
                    if [ "$n" == "n" -o "$n" == "N" ]; then
                        arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
                    else
                        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
                    fi
                fi
            else
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
            fi
        fi
    fi
elif [ "$1" == "uninstall" ]; then
    function removeConfig() {
        ls ~/Library/Application\ Support/com.greengecko.brewall 2>/dev/null | grep initializationed > /dev/null 2>&1
        if [ $? == 0 ]; then 
            rm -rf ~/Library/Application\ Support/com.greengecko.brewall
        fi
        if [ -w $debugPath ]; then
            rm -rf $debugPath
        fi
    }

    function removePackage() {
        if [ "$(uname -m)" == "arm64" ]; then
            if [ "$(which brew)" == "/usr/local/bin/brew" ]; then
                arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
            else
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
            fi
        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
        fi
    }

    if [ "$2" == "--config" ]; then
        removeConfig
    elif [ "$2" == "--purge" ]; then
        removePackage
        removeConfig
    elif [ x$2 == x ]; then
        removePackage
    else
        echo "$IGNORE_UNKNOWN_CMD_TITLE"
        echo "$IGNORE_UNKNOWN_CMD_INFO"
        removePackage
    fi
fi
