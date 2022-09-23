##### Environment Check #####
### OS Check
export ERR_OS="\033[31m$(uname -s) 는 아직 지원하지 않습니다. \033[m"
export ERR_CHK_DPY="\033[31m의존성 패키지를 검증할 수 없기 때문에 종료되었습니다.\033[m"

### Development Tools Check
export INFO_XCS="\033[33mxcode-select 설치를 끝낸 후 다시 실행하여 주세요. \033[m"

### Version Check
export APY_RST="\033[33m변경 사항을 적용하기 위해 다시 실행하여 주세요. \033[m"


##### License #####
export ACT_KEY="\nbrewall 프로젝트 및 스크립트는 위의 MIT 라이선스에 귀속됩니다. \n 위 라이선스에 동의하십니까? (Y/n) > "
export DIS_KEY="라이선스에 동의해야 brewall 프로젝트 및 스크립트를 사용할 수 있습니다. "


##### Directory Create #####
export CONF_DIR_MKDIR="brewall 설정 폴더를 생성하였습니다. 설정 폴더는 \033[0;1m$HOME/Library/Application\ Support/com.greengecko.brewall\033[m에 위치할 것입니다. "
export LOG_DIR_MKDIR_FRONT="brewall 로그 폴더를 생성하였습니다. 모든 로그 파일들은\033[0;1m"
export LOG_DIR_MKDIR_BACK="\033[m에 위치할 것입니다. "


##### Brew #####
### Require Package
export INFO_REQ_BREW="이 brewall 스크립트는 brew 패키지 관리자를 더 사용하기 쉽도록 하는 도구이며 이들이 필수적으로 필요합니다. "

### Instruction
export SYS_STATUS_TITLE="\033[0;1m현재 시스템 사양\033[m"

### Install Abort
export ABT_INSTALL="설취를 취소하였습니다. 필수 패키지를 로드할 수 없으므로 종료합니다. "


##### Uninstall #####
export CONF_DIR_RMDIR="brewall 설정 폴더를 삭제하였습니다. "
export LOG_DIR_RMDIR="brewall 로그 폴더를 삭제하였습니다. "
export PACK_UNINSTALL_SUCCEED="\033[34mBrew가 성공적으로 제거되었습니다!\033[m"
export PACK_UNINSTALL_FAILED="\033[33mBrew가 제거되었지만, 일부 파일이 삭제되지 않았을 수 있습니다. \n삭제되지 못한 파일은 화면에 표시되어 있으니 참고하여 삭제하시기 바랍니다."


##### HomeBrew #####
### HomeBrew Requirements
export HOME_REQ_TITLE="\033[0;1mHomebrew macOS 요구사항\033[m"
export HOME_REQ_CPU="64비트 인텔 CPU 또는 M CPU"
export HOME_REQ_OS="10.13 이상 권장"
export HOME_REQ_DEV="Xcode 와/또는 xcode-select 필요\n"

### HomeBrew Install Guide
export HOME_INSTALL_TITLE="\n\033[0;1mHomebrew 설치 방법\033[m"
export HOME_INSTALL_INFO_1="\033[0;1mhttps://brew.sh/index_ko\033[m 이 사이트에 들어가서 Homebrew를 수동으로 설치하거나"
export HOME_INSTALL_INFO_2="아니면 지금 한번에 설치할 수 있습니다. (제 3자 스크립트를 실행하며 무엇을 할지 설명하고 잠시 대기합니다. )"
export HOME_INSTALL_INFO_3="설치할 경우 라이선스에 동의한 것으로 간주합니다. "
export HOME_INSTALL_CHK="설치하시겠습니까? (Y/n) > "

### Install Method
export HOME_INSTALL_ARM="Native 버전으로 설치하시겠습니까? (Y/n) > "


##### TigerBrew #####
### TigerBrew Requirements
export TIGER_REQ_TITLE="\033[0;1mTigerbrew macOS 요구사항\033[m"
export TIGER_REQ_CPU="Power PC"
export TIGER_REQ_OS="Tiger or Leopard 권장\n"

### TigerBrew Install Guide
export TIGER_INSTALL_TITLE="\n\033[0;1mTigerbrew 설치 방법\033[m"
export TIGER_INSTALL_INFO_1="\033[0;1mhttps://github.com/mistydemeo/tigerbrew\033[m 이 사이트에 들어가서 Tigerbrew를 수동으로 설치하거나"
export TIGER_INSTALL_INFO_2="아니면 지금 한번에 설치할 수 있습니다. (제 3자 스크립트를 실행하며 무엇을 할지 설명하고 잠시 대기합니다. )"
export TIGER_INSTALL_INFO_3="설치할 경우 라이선스에 동의한 것으로 간주합니다. "
export TIGER_INSTALL_CHK="설치하시겠습니까? (Y/n) > "
