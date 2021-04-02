# brewall
## This shell script helps you update your brew package manager.
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/hmDonate)
### Supported brew package manager
- [Homebrew](https://brew.sh)
- [Tigerbrew](https://github.com/mistydemeo/tigerbrew)
### Installation
- [Download](https://github.com/HyeongminKim/brewall/archive/master.zip) the latest version of brewall package.
    - Place the brewall package where you want it.
    - Legacy brewall.sh can be downloaded [here](https://github.com/HyeongminKim/brewall/releases).
- Or in terminal run below command.

    ```
    git clone https://github.com/HyeongminKim/brewall.git [destination]
    ```
- Please add below command to your default shell config file

    ```
    brewall() {
      <shell script destination> $@
    }
    ```
- Now enjoy it
### Trouble shooting
- If you see the **permission denied** error message run command like below.

    ```
    chmod 755 foo.sh
    ```
### Usage: brewall.sh \[command\] \[option\]
- version: Print this script version and environment version. 
- runtime: Print previous brewall launch time. 
- changelog: View update changes
- remove: brew package manager uninstall.
    - --config: brewall config remove.
    - --purge: brew package manager uninstall and brewall config remove.
- help: Print this help.
### Update channels
- First, run the ``git remote update`` command to access the remote branch.
- You can check the supported update channels with the `git branch -r` command.
- You can change the update channel with the ``git checkout -t origin/<branch>`` command.
### Description of the script used
|File Name|Note|
|:----:|:-----|
|brewall.sh|This script is a root script, please only start with this script. (If you run it with another script, it will not work properly.)|
|tools/install.sh|Initial setup and required packages are installed. If the requirements are not met during the check, this script will assist you with the installation.|
|tools/upgrade.sh|Update the locally installed brewall repository to the latest version. See [here](https://github.com/HyeongminKim/brewall\#update-channels) how to change channels.|
|tools/changelog.sh|A script that prints out changes according to the format when the update is successful.|
|tools/extension.sh|Allows the user to write additional shell scripts, which is optional.|

### Localization 
- [Show current support languages](https://github.com/HyeongminKim/brewall/tree/master/localization)
- Localizing new languages
  - Create a folder with the locale code name inside the localization folder and start localization.
- Improvement of existing localized language
  - Thanks for contributing to brewall localization.
### License
This work is licensed under a [MIT License](https://github.com/HyeongminKim/brewall/blob/master/LICENSE).
