#!/bin/bash

########## Validate Maven Project #############
PROJECT_PATH_VALIDATED=false

######## Initial Check for existing Project Path #######
projectPathSetup() {
  ## Check for project in runtime_vars table ####
  projectPathVarChecker
  projectChecker $PROJECT_PATH
}



########## Read and Set Project Path #################
projectPathUpdate() {
  ## Read Project Path if No Path exists
  while [[ -z "$PROJECT_PATH" ]]; do
    read -r -p "Enter project path (maven/npm) projects only): " PROJECT_PATH
    projectChecker "$PROJECT_PATH"
  done

  "$SQLITE_EXEC_PATH" "$DB_NAME" "UPDATE runtime_vars SET project_path='$PROJECT_PATH' WHERE id=1;"
  echo -e "PROJECT_PATH: ${BRED}$PROJECT_PATH${NC}\n"
  "$SQLITE_EXEC_PATH" "$DB_NAME" "INSERT OR REPLACE INTO project (id, project_name, project_path) VALUES ((SELECT id FROM project WHERE project_path='$PROJECT_PATH'), '$PROJECT_NAME', '$PROJECT_PATH');"
}

projectNameUpdate() {
  PROJECT_NAME="${PWD##*/}"
  read -r -p "Do you want to keep the project name ${BLUE}'$PROJECT_NAME'${NC}? (Y/n):" PROJECT_NAME_QUERY
  if [ "$PROJECT_NAME_QUERY" = "n" ]; then
    PROJECT_NAME_QUERY=""
    while [ -z "$PROJECT_NAME_QUERY" ]; do
      read -r -p "Enter project name: " PROJECT_NAME_QUERY
    done
    PROJECT_NAME=$PROJECT_NAME_QUERY
  fi
  "$SQLITE_EXEC_PATH" "$DB_NAME" "UPDATE project SET project_name='$PROJECT_NAME' WHERE project_path='$PROJECT_PATH' ;"
}

##### Find and set Project path from DB ##########
projectPathVarChecker() {
  ## Find Project From local DB
  PROJECT_PATH=$("$SQLITE_EXEC_PATH" "$DB_NAME" "SELECT project_path FROM runtime_vars")
  if [ -z "$PROJECT_PATH" ]; then
      projectGetOrUpdateProjectVars
  fi
  PROJECT_NAME=$("$SQLITE_EXEC_PATH" "$DB_NAME" "SELECT project_name FROM project WHERE project_path='$PROJECT_PATH'");
  echo -e "Project Name: ${BRED}$PROJECT_NAME${NC}\n"
}

### Find and get Project values from Project Table #####
projectGetOrUpdateProjectVars() {
  TEMP_VAL=$("$SQLITE_EXEC_PATH" "$DB_NAME" "SELECT * FROM project WHERE project_path='$PROJECT_PATH'");
  if [[ -z "$TEMP_VAL" ]]; then
    projectPathUpdate
    projectNameUpdateForce
  fi
}

### ForceUpdate project path ###
projectPathUpdateForce() {
  PROJECT_PATH=""
  projectPathUpdate
}

projectNameUpdateForce() {
  PROJECT_NAME=""
  projectNameUpdate
}

projectChecker() {
  if [ -z "${1}" ]; then
    return;
  fi

  pom_file_location="${1}/pom.xml"
  package_file_location="${1}/package.json"
  if [ -f "$pom_file_location" ]; then
    PROJECT_TYPE="maven"
    echo "${BRED}Maven Project${NC}"
  elif [ -f "$package_file_location" ]; then
    PROJECT_TYPE="npm"
    echo "${BRED}NPM Project${NC}"
  else
    echo -e "${BYELLOW}Invalid Project path${NC}. only maven and npm projects are supported\n"
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
