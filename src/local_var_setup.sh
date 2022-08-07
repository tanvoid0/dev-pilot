#!/bin/bash

########## Validate Maven Project #############
projectChecker() {
  pom_file_location="${1}/pom.xml"
  package_file_location="${1}/package.json"
  if [ -f "$pom_file_location" ]; then
    PROJECT_TYPE="maven"
    echo "Maven Project"
  elif [ -f "$package_file_location" ]; then
    PROJECT_TYPE="npm"
    echo "NPM Project"
  else
    echo "Invalid Project path. only maven and npm projects are supported"
    TEMP_VAL=""
    return
  fi
  PROJECT_PATH="$1"
  cd "${1}" || exit
}

########## Read and Set Project Path #################
projectPathSetup() {
  TEMP_VAL=""
  if [ "$1" -eq 0 ]; then
    PROJECT_PATH="$(cat "${VAR_FILE_PATH}"/project_path.txt)"
    TEMP_VAL="$PROJECT_PATH"
  fi
  projectChecker "$TEMP_VAL"
  while [ -z "$TEMP_VAL" ]; do
    read -r -p "Enter project path (maven/npm) projects only): " TEMP_VAL
    projectChecker "$TEMP_VAL"
  done
  echo "$PROJECT_PATH" >"${VAR_FILE_PATH}/project_path.txt"
  PROJECT_NAME="${PWD##*/}"
}

############# Read and Set Namespace ################
namespaceSetup() {
  TEMP_VAL=""
  if [ "$1" -eq 0 ]; then
    NAMESPACE="$(cat "${VAR_FILE_PATH}"/namespace.txt)"
    TEMP_VAL=$NAMESPACE
  fi

  while [ -z "$TEMP_VAL" ]; do
    read -r -p "Enter namespace: " TEMP_VAL
  done
  NAMESPACE=$TEMP_VAL
  export NAMESPACE="${NAMESPACE}"
    echo "$NAMESPACE" >"${VAR_FILE_PATH}/namespace.txt"
}