#!/bin/bash
#
#str="Expands to up to length characters of parameter starting at the character
#       specified by offset. If length is omitted, expands to the substring of parameter
#       starting at the character specified by offset. length and offset are arithmetic
#       expressions (see Shell Arithmetic). This is referred to as Substring Expansion."
#
#loopTest() {
#  for i in {1..10}
#  do
#    echo "Welcome line $i"
#    sleep 1s
#  done
#}

#loopTest | tee $OUTPUT_FILE

cmdProcessorValidator() {
  OUTPUT="$(cat "$OUTPUT_FILE")"
  SUCCESS_STRING="$1"
  FAILED_STRING="$2"
  if [ -z "$SUCCESS_STRING" ]; then
    SUCCESS_STRING="BUILD SUCCESS"
  fi

  if [ -z "$FAILED_STRING" ]; then
    FAILED_STRING="BUILD FAILURE"
  fi

  OUTPUT_TRIM="${OUTPUT: -1500}"
  case "$OUTPUT_TRIM" in
    *"$SUCCESS_STRING"*) bannerPrinter "jet_group" "${GREEN}" ; echo "${BGREEN}Operation completed Successfully${NC}..."; OUTPUT_RESPONSE=true; notifySend "Success" "Command finished successfully" ;;
    *"$FAILED_STRING"*) bannerPrinter "plane_crash" "${RED}" ; echo "${BRED}Operation failed${NC}..."; OUTPUT_RESPONSE=false; notifySend "Failure" "Command failed." error ;;
    *) echo "${RED}Validation not sure. Manually add the validation to filter right...${NC} $OUTPUT_TRIM"; OUTPUT_RESPONSE="";;
  esac
}

############ Beautify and print Command #########
commandPrint() {
  echo "Running command: ${BYELLOW}$1${NC}"
  printf "\n"
  eval "$1"
}

commandPrintAndSave() {
  notifySend "Command Running" "$1"
  commandPrint "$1" | tee "$OUTPUT_FILE"

  if [ "$2" == "validate" ]; then
    cmdProcessorValidator "$3" "$4"
  fi
}