#!/bin/bash

root_path=$(pwd)

# Scripts
scripts_path="$root_path/src"

### TODO: Loader function
auto_pilot_script="$scripts_path/auto_pilot.sh"
beautify_script="$scripts_path/beautify.sh"
distributed_service_script="$scripts_path/distributed_service_script.sh"
files_script="$scripts_path/files.sh"
git_script="$scripts_path/git_script.sh"
liquibase_script="$scripts_path/liquibase.sh"
local_var_setup_script="$scripts_path/local_var_setup.sh"
maven_script="$scripts_path/maven_script.sh"
npm_script="$scripts_path/npm_script.sh"
notify_script="$scripts_path/notify.sh"
os_script="${scripts_path}/os_script.sh"
util_script="$scripts_path/util_script.sh"
vars_script="${scripts_path}/vars.sh"

# Load scripts
. "${vars_script}"

. "${auto_pilot_script}"
. "${beautify_script}"
. "${distributed_service_script}"
. "${files_script}"
. "${git_script}"
. "${liquibase_script}"
. "${local_var_setup_script}"
. "${maven_script}"
. "${npm_script}"
. "${notify_script}"
. "${os_script}"
. "${util_script}"

################# View List of command options ################
optionOutput() {
  ############ Maven Commands ################
  if [ "$PROJECT_TYPE" == "maven" ]; then
    optionGroupTitlePrint "Maven Commands"
    optionPrint "m1" "Maven Test:" "mvn test"
    optionPrint "m2" "Maven Clean Install:" "mvn clean install" true
  elif [ "$PROJECT_TYPE" == "npm" ]; then
    optionGroupTitlePrint "NPM Commands"
    optionPrint "n1" "NPM Clean Install:" "npm ci"
    optionPrint "n2" "NPM Start:" "npm run start"
    optionPrint "n3" "NPM Test:" "npm run test"
    optionPrint "n4" "NPM Test (Mocha):" "npm run test-mocha"
    optionPrint "n5" "NPM Test (Pact):" "npm run test-pact"
    optionPrint "n6" "NPM Test (Coverage):" "npm run test-coverage"
    optionPrint "n7" "NPM Lint:" "npm run lint"
    optionPrint "n8" "NPM Build:" "npm run build" true
  fi

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

    ############## NPM Commands ###############
  'n1') npmScriptRunCI ;;
  'n2') npmScriptRunStart ;;
  'n3') npmScriptRunTest ;;
  'n4') npmScriptRunTest "-mocha" ;;
  'n5') npmScriptRunTest "-pact" ;;
  'n6') npmScriptRunTest "-coverage" ;;
  'n7') npmScriptRunLint ;;
  'n8') npmScriptRunBuild ;;

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
  optionOutput         # Option Viewer
  optionInput          # Option Picker
  optionProcess "$opt" # And Command Execute

  ## End Process
  enterToContinue # Enter to Continue Template
done
