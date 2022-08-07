#!/bin/bash

root_path=$(pwd)

# Scripts
scripts_path="$root_path/src"

beautify_script="$scripts_path/beautify.sh"
distributed_service_script="$scripts_path/distributed_service_script.sh"
files_script="$scripts_path/files.sh"
git_script="$scripts_path/git_script.sh"
liquibase_script="$scripts_path/liquibase.sh"
maven_script="$scripts_path/maven_script.sh"
notify_script="$scripts_path/notify.sh"
os_script="${scripts_path}/os_script.sh"
util_script="$scripts_path/util_script.sh"
vars_script="${scripts_path}/vars.sh"

# Load scripts
. "${vars_script}"


. "${beautify_script}"
. "${distributed_service_script}"
. "${files_script}"
. "${git_script}"
. "${liquibase_script}"
. "${maven_script}"
. "${notify_script}"
. "${os_script}"
. "${util_script}"

################# View List of command options ################
optionOutput() {
  ############ Maven Commands ################
  optionGroupTitlePrint "Maven Commands"
  optionPrint "m1" "Maven Test:" "mvn test"
  optionPrint "m2" "Maven Clean Install:" "mvn clean install" true

  ############ Liquibase Commands #############
  optionGroupTitlePrint "Liquibase Actions"
  optionPrint "l1" "Liquibase test:" "mvn -PLIQUIBASE_PREPARE_FOR_DIFF test"
  optionPrint "l2" "Liquibase update:" "mvn liquibase:update liquibase:diff"
  optionPrint "l3" "Liquibase process:" "liquibase-changelog-master.yml"
  optionPrint "l4" "Liquibase verify:" "mvn -PLIQUIBASE_VERIFY test" true

  ############# Docker Commands #################
  optionGroupTitlePrint "Docker Commands"
  optionPrint "d1" "Docker" "Check Daemon Running"
  optionPrint "d2" "Docker" "Build"
  optionPrint "d3" "Docker" "Push" true

  ############# Kubernetes Commands #############
  optionGroupTitlePrint "Kubernetes Commands"
  optionPrint "k1" "Kubernetes Service" "Upscale"
  optionPrint "k2" "Kubernetes Service" "Downscale"
  optionPrint "k3" "Kubernetes Service" "Restart"
  optionPrint "k4" "Kubernetes Service" "Upscale all services"
  optionPrint "k5" "Kubernetes Service" "Downscale all services"
  optionPrint "k6" "Kubernetes Service" "Run Proxy"
  optionPrint "k7" "Kubernetes Service" "Port Forward"
  optionPrint "k8" "Kubernetes Service" "Debug Port Forward" true

  ############## Git ############################
  optionGroupTitlePrint "Gcloud Commands"
  optionPrint "gc1" "Gcloud login" "gcloud auth login"
  optionPrint "gc2" "Gcloud init" "gcloud init" true

  ############## Git ############################
  optionGroupTitlePrint "Git Commands"
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

  ############## Utility scripts ####################
  optionGroupTitlePrint "Utilities"
  optionPrint "u1" "Conversion" "Base64"
  optionPrint "u2" "ping" "Utility"
  optionPrint "c" "Custom command" "Run any command inside project path" true
  ############## Autopilot ######################
  optionPrint "0" "Autopilot" "Mode" true

  ############ Settings Commands ################
  optionGroupTitlePrint "Configs"
  optionPrint "x" "Toggle" "Banner"
  optionPrint "s1" "Update" "Project Path." false "${PROJECT_PATH}"
  optionPrint "s2" "Update" "Kubernetes Namespace." false "${NAMESPACE}"
  optionPrint "s3" "Update" "Banner Path." true "${BANNER_FILE}"

  ########### End of commands ###################
  echo "Press ${BRED}Ctrl+C${NC} to quit..."
  printf "\n"
}

############## Pick Option ###############
optionInput() {
  read -r -p "Enter an option: ${BYELLOW}" opt
  echo "${NC}"
  printf "\033c"
}

############## Option Process ##################
optionProcess() {
  # shellcheck disable=SC2034
  TEMP_OPT=$1 # Used to highlight option later

  ########### Clear Screen And Print Chosen option #####
  echo "You picked option: ${BPURPLE} ${TEMP_OPT}${NC}. "

  case $TEMP_OPT in '0') autoPilot ;;

    ####### Maven Commands ################
  'm1') mavenTest ;;
  'm2') mavenCleanInstall ;;

    ######## Liquibase Commands ############
  'l1') prepareLiquibaseForInitialTest ;;
  'l2') prepareLiquibaseForDiff ;;
  'l3') processLiquibase ;;
  'l4') validateLiquibase ;;

    ######## Docker Commands ###############
  'd1') dockerRunningValidator ;;
  'd2') dockerActions "build" "${NAMESPACE}" "${PROJECT_NAME}" ;;
  'd3') dockerActions "push" "${NAMESPACE}" "${PROJECT_NAME}" ;;

    ######## Kubernetes Commands ###########
  'k1') kubeActions "up" "${NAMESPACE}" "${PROJECT_NAME}" ;;
  'k2') kubeActions "down" "${NAMESPACE}""${PROJECT_NAME}" ;;
  'k3') kubeActions "restart" "${NAMESPACE}" "${PROJECT_NAME}" ;;
  'k4') kubeActions "upAll" "${NAMESPACE}" ;;
  'k5') kubeActions "downAll" "${NAMESPACE}" ;;
  'k6') kubeActions "proxy" "${NAMESPACE}" ;;
  'k7') kubePortForward ;;
  'k8') kubePortForward "debug" ;;

    ###### Gcloud commands ####################
  'gc1') gcloudLogin ;;
  'gc2') gcloudInit ;;

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
  's3') bannerUpdate ;;

    ####### Invalid option #############
  *) echo "Invalid command... Try again" ;;
  esac
}

prepForAutoPilot() {
  autoPilotLiquibasePrep
}

############ Auto pilot ####################
autoPilot() {
  bannerPrinter "flight_take_off" "${GREEN}"
  echo "Auto pilot mode ${RED}Deployed ✈ ${NC} ..."
  sleep 3s

  prepForAutoPilot

  OUTPUT_RESPONSE=true
  autoPilotMaven
  autoPilotLiquibase
  autoPilotDocker
  autoPilotKubernetes

  if [ "$OUTPUT_RESPONSE" == true ]; then
    bannerPrinter "plane" "${GREEN}"
    echo "${GREEN}Flight landed safely ✈...${NC} Your Process was successful... Enjoy ... "
  else
    bannerPrinter "jet_crash" "${RED}"
    echo "${RED}Your flight crashed ...${NC} it failed in option ${RED}${TEMP_OPT}${NC}.."
    echo "Go back to the main menu, fix things and continue manually."
    echo "Or you can always do a ${GREEN}fresh start ⛸${NC}️..."
  fi
}

############# Move next feature ##########
# @param1 option
# @param2 previous validation required
autoPilotFlyMode() {
  if [ "$2" == false ]; then
    OUTPUT_RESPONSE=true
  fi

  if [ "$OUTPUT_RESPONSE" == true ]; then
    optionProcess "$1"
  fi
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
    PROJECT_PATH="$(cat "${VAR_FILE_PATH}"/project_path.txt)"
    TEMP_VAL=$PROJECT_PATH
  fi

  while [ -z "$TEMP_VAL" ]; do
    read -r -p "Enter project path (maven projects only): " TEMP_VAL
    projectChecker "$TEMP_VAL"
  done
  PROJECT_PATH=$TEMP_VAL
  cd "$PROJECT_PATH" || exit

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

# Initial Setup
setup() {
  createVars
  projectPathSetup 0
  namespaceSetup 0
  initLiquibasePaths
}

resetVars() {
  liquibaseScriptReset
}

######## Main Function ##########

setup
utilScriptGreeting
while true; do
  ## Initiation
  resetVars
  logoViewer # lOGO & Banner Viewer

  ## Process
  optionOutput                    # Option Viewer
  optionInput                     # Option Picker
  optionProcess "$opt"            # And Command Execute

  ## End Process
  enterToContinue                 # Enter to Continue Template
done
