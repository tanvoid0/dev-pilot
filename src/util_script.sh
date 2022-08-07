#!/bin/bash

##### String to Base64 Conversion #############
convertStringToBase64() {
  commandPrint "echo '$1' | base64"
}

########## Base64 to String Conversion #############
convertBase64ToString() {
  commandPrint "echo '$1' | base64 --decode"
}

######## Core Function to convert between strings and base64s #########
base64Conversion() {
  optionPrint "1" "String to" "Base64"
  optionPrint "2" "Base64 to" "String"
  optionPrint "0" "Exit Base64 conversion Utility"

  read -r -p "Enter your choice: " baseOpt
  baseInput=""

  if [ "$baseOpt" == "1" ]; then
    while [ -z "$baseInput" ]; do
      read -r -p "Enter your String: " baseInput
    done
    convertStringToBase64 "$baseInput"
  elif [ "$baseOpt" == "2" ]; then
    while [ -z "$baseInput" ]; do
      read -r -p "Enter your base64 string: " baseInput
    done
    convertBase64ToString "$baseInput"
  elif [ "$baseOpt" == "0" ]; then
    return
  else
    echo "Invalid choice.. Please try again"
  fi
  printf "\n"
  base64Conversion
}

######### Wait until Server comes online then run a command #####
# @param1 host
# @param2 command
pingAndRunCommandWhenAvailable() {
  read -r -p "Checking server status. If you want to run any command whenever it becomes online, please enter your command: " input
  while ! ping -c1 "$1" &>/dev/null; do
    echo "Ping Fail to $1 - $(date)"
  done
  echo "Host Online - $(date)"

  if [ -n "$input" ]; then
    commandPrint "$input"
  fi
}

############# Open Is it down right now? #######
openIsItDownRightNow() {
  openUrl "https://www.isitdownrightnow.com/${1}.html"
}

#### Ping Server ###############
pingServer() {
  commandPrint "ping $1"
}

### Ping a server to check connection status #######
pingUtility() {
  optionPrint "1" "ping a" "Server"
  optionPrint "2" "Check if" "Server is online"
  optionPrint "0" "Exit Base64 conversion Utility"

  baseOpt=""
  while [ -z "$baseOpt" ]; do
    read -r -p "Enter your choice: " baseOpt
  done
  input=""
  while [ -z "$input" ]; do
    read -r -p "Enter your ${RED}host name${NC} or ${RED}ip address:${NC} ${BYELLOW}" input
    echo "${NC}"
  done

  if [ "$baseOpt" == 0 ]; then
    return
  elif [ "$baseOpt" == 1 ]; then
    pingServer "$input"
  elif [ "$baseOpt" == 2 ]; then
    openIsItDownRightNow $input
  else
    echo "Bad input... $baseOpt"
  fi
  printf "\n"

  pingUtility
}

########## Run user defined commands ###################
runCustomCommand() {
  read -r -p "Enter your custom command: ${BYELLOW}" inputCmd
  echo "${NC}"
  if [ -z "$inputCmd" ]; then
    echo "No command passed."
  else
    commandPrint "$inputCmd"
  fi
}

############ Time based greetings
