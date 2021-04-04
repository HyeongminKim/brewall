##### Option #####
### version
export GIT_REVISION="깃 리비전"
export LAST_COMMIT="마지막 커밋"
export BUILD="빌드"

export ERR_DETECT_BREW="brew가 설치되어 있지 않거나 감지되지 않았습니다. "
export ERR_DETECT_GIT="git이 설치되어 있지 않거나 감지되지 않았습니다. "

### remove
export ERR_EXECUTE_UNINSTALLER="\033[31m언인스톨러를 실행할 권한이 없습니다.\033[m"

### help
export SHOW_CMD_USAGE="사용법: $0 [명령] [옵션]"

### unknown command
export IGNORE_UNKNOWN_CMD_TITLE_FRONT="알 수 없는 명령"
export IGNORE_UNKNOWN_CMD_TITLE_BACK="무시됨"
export IGNORE_UNKNOWN_CMD_INFO="brewall 도움말을 보시려면, help 명령을 사용하세요."


##### Compare Time #####
export DOWN_SYMBOL_FRONT="\033[31m▼"
export DOWN_SYMBOL_BACK="초\033[m"
export EQUAL_SYMBOL="- 0 초"
export UP_SYMBOL_FRONT="\033[31m▲"
export UP_SYMBOL_BACK="초\033[m"


##### Check Internet #####
export ERR_INT_CNT="\033[31m인터넷 연결 확인... "
export SYN_INT_CNT="\033[32m연결됨\033[m"


##### Check Dependency #####
export ERR_CHK_DPY="\033[31m의존성 패키지를 검증할 수 없기 때문에 종료되었습니다.\033[m"


##### Logging Current Time #####
export PREV_TIME="[33m 이전 시간: $(date)[0m "
export START_TIME="\033[32m시작 시간: $(date)\033[m"

##### Auto Update #####
export ERR_UPDATE="\033[31m자동 업데이트 도중 에러가 발생하였습니다. 수동으로 진행하여 주세요\033[m"


##### Brew Log Files #####
### Only one brewall log.
export ERR_LOG_SAVED_ONE_TITLE_FRONT="\033[31mbrewall이 실패했거나 경고가 발생하였습니다.\033[m\nbrewall 로그 파일이\033[0;1m"
export ERR_LOG_SAVED_ONE_TITLE_BACK="\033[m 에 위치해 있습니다. "
export ERR_LOG_SAVED_ONE_INFO="----- brew 로그 목록 -----"

### Many brewall logs.
export ERR_LOG_SAVED_MANY_TITLE_FRONT="\033[31mbrewall이 실패했거나 경고가 발생하였습니다.\033[m\nbrewall 로그 파일들이\033[0;1m"
export ERR_LOG_SAVED_MANY_TITLE_BACK="\033[m 에 위치해 있습니다. "
export ERR_LOG_SAVED_MANY_INFO="----- brew 로그 목록 -----"

### brewall has successful
export OK_TITLE="\033[34mbrewall이 성공했습니다.\033[m"


##### Attaching in Logging Current Time with status #####
export FAILURE_INFO="[31m[실패][0m "
export SUCCESS_INFO="[34m[성공][0m "


##### Failed load extension #####
export ERR_EXTENSION="\033[31m익스텐션을 로드하는 도중 에러가 발생하였습니다. \033[m"


##### Recommend add extension.sh file #####
export EXTENSION_INFO_FRONT="추가 명령을 실행하고 싶으시면 extension.sh 파일을\033[0;1m"
export EXTENSION_INFO_BACK="/tools\033[m 디렉토리 안에 두십시오. "

##### Elapsed Time #####
export TIME_USE="소요 시간: "