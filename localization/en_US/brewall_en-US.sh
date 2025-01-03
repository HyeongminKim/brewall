##### Option #####
### version
export GIT_REVISION="git revision"
export LAST_COMMIT="last commit"
export BUILD="build"

export ERR_DETECT_BREW="brew is not installed or not detected"
export ERR_DETECT_GIT="git is not installed or not detected"

### changelog
export ERR_SHOW_CHANGELOG="There is nothing to display because it has never received an update yet."

### remove
export ERR_EXECUTE_UNINSTALLER="\033[31mCan't run uninstaller, Please change permission.\033[m"

### help
export SHOW_CMD_USAGE="USAGE: $0 [COMMAND] [OPTION]"

### unknown command
export IGNORE_UNKNOWN_CMD_TITLE_FRONT="Unknown command"
export IGNORE_UNKNOWN_CMD_TITLE_BACK="Skipping"
export IGNORE_UNKNOWN_CMD_INFO="If you wonder brewall help, Please use help command."


##### Compare Time #####
export DOWN_SYMBOL_FRONT="\033[31m▼"
export DOWN_SYMBOL_BACK="sec\033[m"
export EQUAL_SYMBOL="- 0 sec"
export UP_SYMBOL_FRONT="\033[32m▲"
export UP_SYMBOL_BACK="sec\033[m"


##### Check Internet #####
export ERR_INT_CNT="\033[31mCheck your internet connection... "
export SYN_INT_CNT="\033[32mConnected\033[m"


##### Check Dependency #####
export ERR_CHK_DPY="\033[31mExited because dependency package couldn't be verified.\033[m"


##### Logging Current Time #####
export PREV_TIME="[33m Previous time: $(date)[0m "
export START_TIME="\033[32mInitiated time: $(date)\033[m"
export CNT_TIME="\033[32m  Current time: $(date)\033[m"

##### Auto Update #####
export ERR_UPDATE="\033[31mAn error occurred during automatic update. By going manually\033[m"


##### Brew Log Files #####
### Only one brewall log.
export ERR_LOG_SAVED_ONE_TITLE_FRONT="\033[31mbrewall has failed and/or occurred warning.\033[m\nbrewall log file located\033[0;1m"
export ERR_LOG_SAVED_ONE_TITLE_BACK="\033[m"
export ERR_LOG_SAVED_ONE_INFO="----- brew log list -----"

### Many brewall logs.
export ERR_LOG_SAVED_MANY_TITLE_FRONT="\033[31mbrewall has failed and/or occurred warning.\033[m\nbrewall log files located\033[0;1m"
export ERR_LOG_SAVED_MANY_TITLE_BACK="\033[m"
export ERR_LOG_SAVED_MANY_INFO="----- brew logs list -----"

### brewall has successful
export OK_TITLE="\033[34mbrewall has successful.\033[m"


##### Attaching in Logging Current Time with status #####
export FAILURE_INFO="[31m[FAILED][0m "
export SUCCESS_INFO="[34m[SUCCEED][0m "

##### extension.sh file check #####
export CSM_CHECK_EXTENSION="extension.sh checksum:"
export CHECK_OPERATION="Action to run(y: execute, n: abort, d: quicklook) > "
export EXECUTE_EXTENSION_ABORT="User aborted extension.sh file execution."

##### Failed load extension #####
export ERR_EXTENSION="\033[31mAn error occurred while loading the extension.\033[m"


##### Recommend add extension.sh file #####
export EXTENSION_INFO_FRONT="If you want to run additional commands, place the extension.sh file in the\033[0;1m"
export EXTENSION_INFO_BACK="/tools\033[m directory."

##### Elapsed Time #####
export TIME_USE="Elapsed Time: "
