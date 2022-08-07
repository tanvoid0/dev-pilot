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

createVars() {
  if [ ! -d "$VAR_FILE_PATH" ]; then
    mkdir "$VAR_FILE_PATH"
  fi

  # Var files
  var_files=("banner" "logo" "namespace" "project_path")

  for i in "${var_files[@]}"; do
    if [ ! -e "${VAR_FILE_PATH}/$i.txt" ]; then
      touch "$VAR_FILE_PATH/$i.txt"
    fi
  done
}