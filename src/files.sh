#!/bin/bash

### Read a file line by line ########
readFile() {
	while IFS= read -r line; do
		echo "$line"
	done < "$1"
}


readFileToVar() {
  OUTPUT="$(cat "$1")"
  echo "$OUTPUT"
}

readOutputFile() {
  # shellcheck disable=SC2154
  OUTPUT="$(readFileToVar "$OUTPUT_FILE")"
}