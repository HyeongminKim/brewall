#!/bin/bash

debugPath=~/Library/Logs/Homebrew
version=1.0.0
build=1A001

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

