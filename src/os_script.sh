#!/bin/bash
OS=""

########## Initialize OS with running OS Name ######
initOSName() {
  case "$OSTYPE" in
    solaris*) OS="SOLARIS" ;;
    darwin*)  OS="OSX";;
    linux*)   OS="LINUX" ;;
    bsd*)     OS="BSD" ;;
    msys*)    OS="WINDOWS" ;;
    cygwin*)  OS="WINDOWS" ;;
    *)        OS="$OSTYPE" ;;
  esac
  echo "Operating System: $OS"
}

openUrl() {
  if [ "$OS" == "WINDOWS" ]; then
    start "$1"
  fi
  echo "If the browser didn't open a new tab, please manually insert the url"
  echo -e "\e]8;;$1\a$1\e]8;;\a"
}

initOSName