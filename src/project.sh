#!/bin/bash

########## Validate Maven Project #############
PROJECT_PATH_VALIDATED=false

########## Read and Set Project Path #################
projectPathSetup() {
  ## Find Project From local DB
  PROJECT_PATH=$("$SQLITE_EXEC_PATH" "$DB_NAME" "SELECT project_path FROM runtime_vars")
  projectChecker "$PROJECT_PATH"

  ## Read Project Path if No Path exists
  while [[ -z "$PROJECT_PATH" ]]; do
    read -r -p "Enter project path (maven/npm) projects only): " PROJECT_PATH
    projectChecker "$PROJECT_PATH"
  done
  "$SQLITE_EXEC_PATH" "$DB_NAME" "UPDATE runtime_vars SET project_path='$PROJECT_PATH' WHERE id=1;"
  echo "PROJECT_PATH: ${GREEN}$PROJECT_PATH${NC}"
  PROJECT_NAME="${PWD##*/}"
  read -r -p "Do you want to keep the project name $PROJECT_NAME? (Y/n):" PROJECT_NAME_QUERY
  if [ "$PROJECT_NAME_QUERY" = "n" ]; then
    while [ -z "$PROJECT_NAME_QUERY" ]; do
      read -r -p "Enter project name: " PROJECT_NAME_QUERY
    done
    PROJECT_NAME=$PROJECT_NAME_QUERY
  fi

  "$SQLITE_EXEC_PATH" "$DB_NAME" "INSERT OR REPLACE INTO project (id, project_path, project_name) VALUES ((SELECT id FROM project WHERE project_path='$PROJECT_PATH'), '$PROJECT_NAME', '$PROJECT_PATH');"
  "$SQLITE_EXEC_PATH" "$DB_NAME" "UPDATE runtime_vars SET project_path='$PROJECT_PATH' WHERE id=1"
}

projectChecker() {
  if [ -z "${1}" ]; then
    return;
  fi

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
    PROJECT_PATH=""
    return
  fi
  PROJECT_PATH="$1"
  cd "${1}" || exit
}

######## Project path validator
# 1. project path
# 2. file with type extension to validate right project type
# 3. set custom project type name
projectPathValidator() {
  PROJECT_PATH_VALIDATED=false
  if [ -f "${1}/${2}" ]; then
    PROJECT_TYPE="${3}"
  else
    echo "Invalid Project path. only maven and npm projects are supported"
    PROJECT_TYPE_INPUT=""
  fi
  cd "${1}" || exit
}
