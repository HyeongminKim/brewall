#!/bin/bash

debugPath=~/Library/Logs/Homebrew

if [ "$(uname -s)" != "Darwin" ]; then
    if [ $LANG == "ko_KR.UTF-8" ]; then
        echo -e "\033[31m$(uname -s) 는 아직 지원하지 않습니다. \033[m"
    else
        echo -e "\033[31m$(uname -s) does not support yet.\033[m"
    fi
    exit 1
fi

if [ "$1" == "install" ]; then
    ls ~/Library/Application\ Support/com.greengecko.brewall 2>/dev/null | grep initializationed > /dev/null 2>&1
    if [ $? != 0 ]; then
        mkdir ~/Library/Application\ Support/com.greengecko.brewall
        touch ~/Library/Application\ Support/com.greengecko.brewall/initializationed
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -e "brewall 설정 폴더를 생성하였습니다. 설정 폴더는 \033[0;1m$HOME/Library/Application\ Support/com.greengecko.brewall\033[m에 위치할 것입니다. "
        else
            echo -e "brewall config folder created. This config folder path is \033[0;1m$HOME/Library/Application\ Support/com.greengecko.brewall\033[m"
        fi
    fi

    if [ -d $debugPath ]; then
        echo "" > /dev/null
    else
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
            echo "이 brewall 스크립트는 brew 패키지 관리자를 더 사용하기 쉽도록 하는 도구이며 이들이 필수적으로 필요합니다. "

            echo -e "\033[0;1m현재 시스템 사양\033[m"
            echo "CPU: $(sysctl -n machdep.cpu.brand_string)"
            echo "$(sw_vers -productName) $(sw_vers -productVersion)"

            echo -e "\033[0;1mHomebrew macOS 요구사항\033[m"
            echo -e "64비트 인텔 CPU (M CPU는 아직 완전히 지원되지 않습니다. \033[0;1mhttps://github.com/Homebrew/brew/issues/7857\033[m)"
            echo "10.13 이상 권장"
            echo -e "Xcode 와/또는 xcode-select 필요\n"

            echo -e "\033[0;1mTigerbrew macOS 요구사항\033[m"
            echo "Power PC"
            echo "Tiger or Leopard 권장"

            echo -n "어떤 패키지 관리자를 설치하시겠습니까? (H/t) > "
        else
            echo "This brewall script require brew. Because extend of these tools."

            echo -e "\033[0;1mCurrent system specifications\033[m"
            echo "CPU: $(sysctl -n machdep.cpu.brand_string)"
            echo "$(sw_vers -productName) $(sw_vers -productVersion)"
            
            echo -e "\033[0;1mHomebrew macOS Requirements\033[m"
            echo -e "64bit Intel CPU (M CPU does not fully support yet. \033[0;1mhttps://github.com/Homebrew/brew/issues/7857\033[m)"
            echo "10.13 or higher recommand"
            echo -e "Xcode and/or xcode-select require\n"

            echo -e "\033[0;1mTigerbrew macOS Requirements\033[m"
            echo "Power PC"
            echo "Tiger or Leopard recommand"

            echo -n "What would you like install brew package? (H/t) > "
        fi
        read n
        if [ "$n" == "t" -o "$n" == "T" ]; then
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -e "\033[0;1mTigerbrew 설치 방법\033[m"
                echo -e "\033[0;1mhttps://github.com/mistydemeo/tigerbrew\033[m 이 사이트에 들어가서 Tigerbrew를 수동으로 설치하거나"
                echo "아니면 지금 한번에 설치할 수 있습니다. (제 3자 스크립트를 실행하며 무엇을 할지 설명하고 잠시 대기합니다. )"
                echo -n "설치하시겠습니까? (Y/n) > "
            else
                echo -e "\033[0;1mTigerbrew Installation guide\033[m"
                echo -e "Please enter this site \033[0;1mhttps://github.com/mistydemeo/tigerbrew\033[m and manual install Tigerbrew or "
                echo "Install now on this script. (Execute Third party script and explains what it will do and then pauses before it does it. )"
                echo -n "Install Tigerbrew now? (Y/n) > "
            fi
            read n
            if [ "$n" == "n" -o "$n" == "N" ]; then
                if [ $LANG == "ko_KR.UTF-8" ]; then
                    echo "설취를 취소하였습니다. 필수 패키지를 로드할 수 없으므로 종료합니다. "
                else
                    echo "Installation aborted. Can not load require package, terminating."
                fi
                exit 1
            fi
            ruby -e "$(curl -fsSkL raw.github.com/mistydemeo/tigerbrew/go/install)"
        else
            if [ $LANG == "ko_KR.UTF-8" ]; then
                echo -e "\033[0;1mHomebrew 설치 방법\033[m"
                echo -e "\033[0;1mhttps://brew.sh/index_ko\033[m 이 사이트에 들어가서 Homebrew를 수동으로 설치하거나"
                echo "아니면 지금 한번에 설치할 수 있습니다. (제 3자 스크립트를 실행하며 무엇을 할지 설명하고 잠시 대기합니다. )"
                echo -n "설치하시겠습니까? (Y/n) > "
            else
                echo -e "\033[0;1mHomebrew Installation guide\033[m"
                echo -e "Please enter this site \033[0;1mhttps://brew.sh\033[m and manual install Homebrew or "
                echo "Install now on this script. (Execute Third party script and explains what it will do and then pauses before it does it. )"
                echo -n "Install Homebrew now? (Y/n) > "
            fi
            read n
            if [ "$n" == "n" -o "$n" == "N" ]; then
                if [ $LANG == "ko_KR.UTF-8" ]; then
                    echo "설취를 취소하였습니다. 필수 패키지를 로드할 수 없으므로 종료합니다. "
                else
                    echo "Installation aborted. Can not load require package, terminating."
                fi
                exit 1
            fi
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
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
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo -n "어떤 brew 패키지 관리자를 설치하셨습니까? (H/t) > "
        else
            echo -n "Which brew package manager did you install? (H/t) > "
        fi
        read n
        if [ "$n" == "t" -o "$n" == "T" ]; then
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
        fi
    }
    if [ "$2" == "--dry-run" ]; then
        removeConfig
    elif [ "$2" == "--purge" ]; then
        removePackage
        removeConfig
    elif [ x$2 == x ]; then
        removePackage
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo "$2 은 알 수 없는 명령이며 무시됩니다. "
            echo "brewall의 도움말을 보시려면 help 명령을 사용하십시오. "
        else
            echo "Unknown command $2 Skipping."
            echo "If you wonder brewall help, Please use help command. "
        fi
        removePackage
    fi
fi
