##### Option #####
### version
export GIT_REVISION="git revision"
export LAST_COMMIT="last commit"
export BUILD="build"

export ERR_DETECT_BREW="brew is not installed or not detected"
export ERR_DETECT_GIT="git is not installed or not detected"

### remove
export ERR_EXECUTE_UNINSTALLER="\e[31mCan't run uninstaller, Please change permission.\e[m"

### help
export SHOW_CMD_USAGE="USAGE: $0 [COMMAND] [OPTION]"

### unknown command
export IGNORE_UNKNOWN_CMD_TITLE_FRONT="Unknown command"
export IGNORE_UNKNOWN_CMD_TITLE_BACK="Skipping"
export IGNORE_UNKNOWN_CMD_INFO="If you wonder brewall help, Please use help command."


##### Compare Time #####
export DOWN_SYMBOL_FRONT="\e[31m▼"
export DOWN_SYMBOL_BACK="sec\e[m"
export EQUAL_SYMBOL="- 0 sec"
export UP_SYMBOL_FRONT="\e[32m▲"
export UP_SYMBOL_BACK="sec\e[m"


##### Check Internet #####
export ERR_INT_CNT="\e[31mCheck your internet connection... "
export SYN_INT_CNT="\e[32mConnected\e[m"


##### Check Dependency #####
export ERR_CHK_DPY="\e[31mExited because dependency package couldn't be verified.\e[m"


##### Logging Current Time #####
export PREV_TIME="[33m Previous time: $(date)[0m "
export START_TIME="\e[32mInitiated time: $(date)\e[m"

##### Auto Update #####
export ERR_UPDATE="\e[31mAn error occurred during automatic update. By going manually\e[m"


##### Brew Log Files #####
### Only one brewall log.
export ERR_LOG_SAVED_ONE_TITLE_FRONT="\e[31mbrewall has failed and/or occurred warning.\e[m\nbrewall log file located\e[0;1m"
export ERR_LOG_SAVED_ONE_TITLE_BACK="\e[m"
export ERR_LOG_SAVED_ONE_INFO="----- brew log list -----"

### Many brewall logs.
export ERR_LOG_SAVED_MANY_TITLE_FRONT="\e[31mbrewall has failed and/or occurred warning.\e[m\nbrewall log files located\e[0;1m"
export ERR_LOG_SAVED_MANY_TITLE_BACK="\e[m"
export ERR_LOG_SAVED_MANY_INFO="----- brew logs list -----"

### brewall has successful
export OK_TITLE="\e[34mbrewall has successful.\e[m"


##### Attaching in Logging Current Time with status #####
export FAILURE_INFO="[31m[FAILED][0m "
export SUCCESS_INFO="[34m[SUCCEED][0m "

##### extension.sh file check #####
export CSM_CHECK_EXTENSION="extension.sh checksum:"
export CHECK_OPERATION="Action to run(y: execute, n: abort, d: quicklook) > "
export EXECUTE_EXTENSION_ABORT="User aborted extension.sh file execution."

##### Failed load extension #####
export ERR_EXTENSION="\e[31mAn error occurred while loading the extension.\e[m"


##### Recommend add extension.sh file #####
export EXTENSION_INFO_FRONT="If you want to run additional commands, place the extension.sh file in the\e[0;1m"
export EXTENSION_INFO_BACK="/tools\e[m directory."

##### Elapsed Time #####
export TIME_USE="Elapsed Time: "