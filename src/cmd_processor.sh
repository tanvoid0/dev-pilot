#!/bin/bash

str="Expands to up to length characters of parameter starting at the character
       specified by offset. If length is omitted, expands to the substring of parameter
       starting at the character specified by offset. length and offset are arithmetic
       expressions (see Shell Arithmetic). This is referred to as Substring Expansion."

loopTest() {
  for i in {1..10}
  do
    echo "Welcome line $i"
    sleep 1s
  done
}

OUTPUT_FILE="D:\Workspace\config\scripts\output\output.txt"

#loopTest | tee $OUTPUT_FILE

cmdOutputResponseValidator() {
  OUTPUT="$(cat "$OUTPUT_FILE")"
  echo "Output response"
  OUTPUT_TRIM="${OUTPUT: -500}"
  case "$OUTPUT_TRIM" in
    *"BUILD SUCCESS"*) echo "Operation completed Successfully..."; OUTPUT_RESPONSE=true ;;
    *"BUILD FAILED"*) echo "Operation failed..."; OUTPUT_RESPONSE=false ;;
    *) echo "Not sure... $OUTPUT_TRIM"
  esac
}

cmdOutputResponseValidator