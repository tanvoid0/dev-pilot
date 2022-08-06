#!/bin/bash

root_path=$(pwd)

# Scripts
scripts_path="$root_path/src"

beautify_script="$scripts_path/beautify.sh"
dockube_script="$scripts_path/dockube.sh"
git_script="$scripts_path/git_script.sh"
liquibase_script="$scripts_path/liquibase.sh"
maven_script="$scripts_path/maven_script.sh"
os_script="${scripts_path}/os_script.sh"
util_script="$scripts_path/util_script.sh"
vars_script="${scripts_path}/vars.sh"

# Load scripts
. "${beautify_script}"
. "${dockube_script}"
. "${git_script}"
. "${liquibase_script}"
. "${maven_script}"
. "${os_script}"
. "${util_script}"
. "${vars_script}"

################# View List of command options ################
optionPicker() {
  ############ Maven Commands ################
  optionPrint "m1" "Maven Test:" "mvn test"
  optionPrint "m2" "Maven Clean Install:" "mvn clean install" true

  ############ Liquibase Commands #############
  optionPrint "l1" "Liquibase:" "Prepare"
  optionPrint "l2" "Liquibase:" "Verify" true

  ############# Docker Commands #################
  optionPrint "d1" "Docker" "Build"
  optionPrint "d2" "Docker" "Push" true

  ############# Kubernetes Commands #############
  optionPrint "k1" "Kubernetes Service" "Upscale"
  optionPrint "k2" "Kubernetes Service" "Downscale"
  optionPrint "k3" "Kubernetes Service" "Restart"
  optionPrint "k4" "Kubernetes Service" "Upscale all services"
  optionPrint "k5" "Kubernetes Service" "Downscale all services"
  optionPrint "k6" "Kubernetes Service" "Run Proxy" true

  ############## Git ############################
  optionPrint "g1" "Git Fetch:" "git fetch"
  optionPrint "g2" "Git Add All:" "git add ."
  optionPrint "g3" "Git Add src folder:" "git add src/"
  optionPrint "g4" "Git status:" "git status"
  optionPrint "g5" "Git commit:" "git commit -m \$feature: \$message"
  optionPrint "g6" "Git commit amend:" "git commit --amend --no-edit"
  optionPrint "g7" "Git push:" "git push"
  optionPrint "g8" "Git push Force With Lease:" "git push --force-with-lease"
  optionPrint "g9" "Git squash n commits": "git rebase -i Head~n"
  optionPrint "g10" "Git Rebase:" "git rebase origin/develop" true

  ############## Autopilot ######################
  optionPrint "0" "Autopilot" "Mode" true

  ############## Utility scripts ####################
  optionPrint "u1" "Conversion" "Base64"
  optionPrint "u2" "ping" "Utility"
  optionPrint "c" "Custom command" "Run any command inside project path" true

  ############ Settings Commands ################
  optionPrint "x" "Toggle" "Banner"
  optionPrint "s1" "Update" "Project Path." false "${PROJECT_PATH}"
  optionPrint "s2" "Update" "Kubernetes Namespace." true "${NAMESPACE}"

  ########### End of commands ###################
  echo "Press ${BRED}Ctrl+C${NC} to quit..."
  printf "\n"
}

############## Pick Option and Execute ###############
optionExecutor() {
  read -r -p "Enter an option: ${BYELLOW}" opt
  echo "${NC}"
  # shellcheck disable=SC2034
  TEMP_OPT=$opt # Used to highlight option later

  ########### Clear Screen And Print Chosen option #####
  printf "\033c"
  echo "You picked option: ${BPURPLE} ${opt}${NC}. "

  case $opt in '0') echo "Sorry to disappoint you! Still working on it!" ;;

    ####### Maven Commands ################
  'm1') mavenTest ;;
  'm2') mavenCleanInstall ;;

    ######## Liquibase Commands ############
  'l1') prepareLiquibase "$PROJECT_PATH" ;;
  'l2') validateLiquibase ;;

    ######## Docker Commands ###############
  'd1') dockerActions "build" "${NAMESPACE}" "${PROJECT_NAME}" ;;
  'd2') dockerActions "push" "${NAMESPACE}" "${PROJECT_NAME}" ;;

    ######## Kubernetes Commands ###########
  'k1') kubeActions "up" "${NAMESPACE}" "${PROJECT_NAME}" ;;
  'k2') kubeActions "down" "${NAMESPACE}""${PROJECT_NAME}" ;;
  'k3') kubeActions "restart" "${NAMESPACE}" "${PROJECT_NAME}" ;;
  'k4') kubeActions "upAll" "${NAMESPACE}" ;;
  'k5') kubeActions "downAll" "${NAMESPACE}" ;;
  'k6') kubeActions "proxy" "${NAMESPACE}" ;;

    ############### Git Commands #############
  'g1') gitFetch ;;
  'g2') gitAddAll ;;
  'g3') gitAddSrc ;;
  'g4') gitStatus ;;
  'g5') gitCommit ;;
  'g6') gitCommitAmend ;;
  'g7') gitPush ;;
  'g8') gitPushForceWithLease ;;
  'g9') gitSquash ;;
  'g10') gitRebase ;;

    ################### Utility Commands ##############
  'u1') base64Conversion ;;
  'u2') pingUtility ;;
  'c') runCustomCommand ;;

    ####### Settings & Configs #############
  'x') toggleBanner ;;
  's1') projectPathSetup 1 ;;
  's2') namespaceSetup 1 ;;

    ####### Invalid option #############
  *) echo "Invalid command... Try again" ;;
  esac
}

########## Validate Maven Project #############
projectChecker() {
  pom_file_location="${1}/pom.xml"
  if [ -f "$pom_file_location" ]; then
    cd "${1}" || exit
  else
    echo "Invalid Maven Project path"
    TEMP_VAL=""
  fi
}

########## Read and Set Project Path #################
projectPathSetup() {
  TEMP_VAL=""
  if [ "$1" -eq 0 ]; then
    PROJECT_PATH="$(cat "${root_path}"/vars/project_path.txt)"
    TEMP_VAL=$PROJECT_PATH
  fi

  while [ -z "$TEMP_VAL" ]; do
    read -r -p "Enter project path (maven projects only): " TEMP_VAL
    projectChecker "$TEMP_VAL"
  done
  PROJECT_PATH=$TEMP_VAL
  cd "$PROJECT_PATH" || exit

  echo "$PROJECT_PATH" >"${root_path}/vars/project_path.txt"
  PROJECT_NAME="${PWD##*/}"
}


############# Read and Set Namespace ################
namespaceSetup() {
  TEMP_VAL=""
  if [ "$1" -eq 0 ]; then
    NAMESPACE="$(cat "${root_path}"/vars/namespace.txt)"
    TEMP_VAL=$NAMESPACE
  fi

  while [ -z "$TEMP_VAL" ]; do
    read -r -p "Enter namespace: " TEMP_VAL
  done
  NAMESPACE=$TEMP_VAL

  echo "$NAMESPACE" >"${root_path}/vars/namespace.txt"
}

# Initial Setup
setup() {
  projectPathSetup 0
  namespaceSetup 0
}


######## Main Function ##########

setup
while true; do
  logoViewer        # lOGO & Banner Viewer
  optionPicker      # Option Viewer
  optionExecutor    # Option Picker And Command Execute
  enterToContinue   # Enter to Continue Template
done
