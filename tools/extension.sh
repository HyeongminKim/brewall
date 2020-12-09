#!/bin/bash

errorCount=0

# This section can be modified. 

if [ $LANG == "ko_KR.UTF-8" ]; then
    echo "MacVim.app 가상본 만드는 중..."
else
    echo "Creating MacVim.app alias..."
fi
macvimPath=$(find /usr/local/Cellar/macvim/ -name "MacVim.app")
if [ "$macvimPath" != "" ]; then
    ln -sF $macvimPath ~/Applications/
    if [ $? == 0 ]; then
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo "MacVim.app 가상본을 성공적으로 만들었습니다."
        else
            echo "Successfully create MacVim.app alias."
        fi
    else
        if [ $LANG == "ko_KR.UTF-8" ]; then
            echo "MacVim.app 가상본을 만드는데 에러가 발생하였습니다."
        else
            echo "Failed to create MacVim.app alias."
        fi
        errorCount=$((errorCount+1))
    fi
fi



# Please do not modify the source code below. 

if [ $errorCount -gt 0 ]; then
    exit 1
else
    exit 0
fi
