#!/bin/bash

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
  beautifyOptionPrint "1" "ping a" "Server"
  beautifyOptionPrint "2" "Check if" "Server is online"
  beautifyOptionPrint "0" "Exit Base64 conversion Utility"

  baseOpt=""
  while [ -z "$baseOpt" ]; do
    read -r -p "Enter your choice: " baseOpt
  done

  if [ "$baseOpt" == 0 ]; then
    return
  elif [ "$baseOpt" == 1 ]; then
    readServerUrl
    pingServer "$input"
  elif [ "$baseOpt" == 2 ]; then
    readServerUrl
    openIsItDownRightNow "$input"
  else
    echo "Bad input... $baseOpt"
  fi
  printf "\n"

  pingUtility
}

readServerUrl() {
  input=""
  while [ -z "$input" ]; do
    read -r -p "Enter your ${RED}host name${NC} or ${RED}ip address:${NC} ${BYELLOW}" input
    echo "${NC}"
  done
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

############ Time based greetings based on Time of day ######
utilScriptGreeting() {
  TIME_OF_DAY=$(date +%H)
  if [ "$TIME_OF_DAY" -lt 12 ]; then
    bannerPrinter "greet/coffee_morning" "$PURPLE"
  elif [ "$TIME_OF_DAY" -lt 18 ]; then
    bannerPrinter "greet/coffee_maker" "$PURPLE"
  else
    bannerPrinter "greet/computer_evening" "$PURPLE"
  fi

  beautifyLogoViewer

  utilCountdownPrinter "Welcome to ${BGREEN}DevPilot${NC}. Pilot Engage in: " 5
  beautifyClearScreen
}

utilCountdownPrinter() {
  printf "%s" "$1"
  for ((i=$2-1; i>=0; i=i-1)); do
    printf " %s%03ds\b\b\b\b\b${NC}" "${BRED}" "$i"
    sleep 1s
  done
}