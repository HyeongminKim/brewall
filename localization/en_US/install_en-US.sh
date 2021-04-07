##### Environment Check #####
### OS Check
export ERR_OS="\033[31m$(uname -s) does not support yet.\033[m"

### Development Tools Check
export INFO_XCS="\033[33mAfter you finish installing xcode-select, run it again.\033[m"

### Version Check
export APY_RST="\033[33mPlease run again to apply the changes.\033[m"


##### License #####
export ACT_KEY="\nThe brewall projects and scripts belong to the MIT license above. \nDo you accept the above license? (Y/n) > "
export DIS_KEY="You should agree to the license before you can use brewall project and scripts."


##### Directory Create #####
export CONF_DIR_MKDIR="brewall config folder created. This config folder path is \033[0;1m$HOME/Library/Application\ Support/com.greengecko.brewall\033[m"
export LOG_DIR_MKDIR_FRONT="brewall log folder created. All logs file are located in\033[0;1m"
export LOG_DIR_MKDIR_BACK="\033[m"


##### Brew #####
### Require Package
export INFO_REQ_BREW="This brewall script require brew. Because extend of these tools."

### Instruction
export SYS_STATUS_TITLE="\033[0;1mCurrent system specifications\033[m"

### Install Abort
export ABT_INSTALL="Installation aborted. Can not load require package, terminating."


##### Uninstall #####
export CONF_DIR_RMDIR="brewall config folder deleted. "
export LOG_DIR_RMDIR="brewall log folder deleted. "
export PACK_UNINSTALL="Brew has been removed. Delete the remaining directories as displayed on the screen. "


##### HomeBrew #####
### HomeBrew Requirements
export HOME_REQ_TITLE="\033[0;1mHomebrew macOS Requirements\033[m"
export HOME_REQ_CPU="64bit Intel CPU or M CPU"
export HOME_REQ_OS="10.13 or higher recommend"
export HOME_REQ_DEV="Xcode and/or xcode-select require\n"

### HomeBrew Install Guide
export HOME_INSTALL_TITLE="\n\033[0;1mHomebrew Installation guide\033[m"
export HOME_INSTALL_INFO_1="Please enter this site \033[0;1mhttps://brew.sh\033[m and manual install Homebrew or "
export HOME_INSTALL_INFO_2="Install now on this script. (Execute Third party script and explains what it will do and then pauses before it does it. )"
export HOME_INSTALL_INFO_3="By installing, you are deemed to have accepted the license."
export HOME_INSTALL_CHK="Install Homebrew now? (Y/n) > "

### Install Method
export HOME_INSTALL_ARM="Would you like to install the Native version? (Y/n) > "


##### TigerBrew #####
### TigerBrew Requirements
export TIGER_REQ_TITLE="\033[0;1mTigerBrew macOS Requirements\033[m"
export TIGER_REQ_CPU="Power PC"
export TIGER_REQ_OS="Tiger or Leopard recommend\n"

### TigerBrew Install Guide
export TIGER_INSTALL_TITLE="\n\033[0;1mTigerbrew Installation guide\033[m"
export TIGER_INSTALL_INFO_1="Please enter this site \033[0;1mhttps://github.com/mistydemeo/tigerbrew\033[m and manual install Tigerbrew or "
export TIGER_INSTALL_INFO_2="Install now on this script. (Execute Third party script and explains what it will do and then pauses before it does it. )"
export TIGER_INSTALL_INFO_3="By installing, you are deemed to have accepted the license."
export TIGER_INSTALL_CHK="Install Tigerbrew now? (Y/n) > "
