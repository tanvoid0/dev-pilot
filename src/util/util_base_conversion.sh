#!/bin/bash

##### String to Base64 Conversion #############
utilConvertStringToBase64() {
  commandPrint "echo '$1' | base64"
}

########## Base64 to String Conversion #############
utilConvertBase64ToString() {
  commandPrint "echo '$1' | base64 --decode"
}

######## Core Function to convert between strings and base64s #########
utilBase64Conversion() {
  beautifyOptionPrint "1" "String to" "Base64"
  beautifyOptionPrint "2" "Base64 to" "String"
  beautifyOptionPrint "0" "Exit Base64 conversion Utility"

  read -r -p "Enter your choice: " baseOpt
  baseInput=""

  if [ "$baseOpt" == "1" ]; then
    while [ -z "$baseInput" ]; do
      read -r -p "Enter your String: " baseInput
    done
    utilConvertStringToBase64 "$baseInput"
  elif [ "$baseOpt" == "2" ]; then
    while [ -z "$baseInput" ]; do
      read -r -p "Enter your base64 string: " baseInput
    done
    utilConvertBase64ToString "$baseInput"
  elif [ "$baseOpt" == "0" ]; then
    return
  else
    echo "Invalid choice.. Please try again"
  fi
  printf "\n"
  utilBase64Conversion
}
