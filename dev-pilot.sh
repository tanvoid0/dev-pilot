#!/bin/bash

root_path=$(pwd)

# Scripts
scripts_path="$root_path/src"
loadScripts() {
  # shellcheck disable=SC1090
  . "${scripts_path}/${1}.sh"
}

# Load scripts
loadScripts "vars"
loadScripts "db"

loadScripts "auto_pilot"
loadScripts "beautify"
loadScripts "cmd_processor"
loadScripts "docker_script"
loadScripts "files"
loadScripts "gcloud_script"
loadScripts "git_script"
loadScripts "kube_script"
loadScripts "liquibase"
loadScripts "local_var_setup"
loadScripts "maven_script"
loadScripts "npm_script"
loadScripts "notify"
loadScripts "project"
loadScripts "os_script"
loadScripts "util_script"
loadScripts "util/util_base_conversion"

################# View List of command options ################
optionOutput() {
  if [ "$PROJECT_TYPE" == "maven" ]; then
    ############ Maven Commands ################
    beautifyOptionGroupTitlePrint "Maven Commands"
    beautifyOptionPrint "m0" "AutoPilot" "Maven & Liquibase"
    beautifyOptionPrint "m1" "Maven Clean Install:" "Without tests"
    beautifyOptionPrint "m2" "Maven Test:" "mvn test"
    beautifyOptionPrint "m3" "Maven Clean Install:" "mvn clean install" true

    ############ Liquibase Commands #############
    beautifyOptionGroupTitlePrint "Liquibase Actions"
    beautifyOptionPrint "l1" "Liquibase test:" "mvn -PLIQUIBASE_PREPARE_FOR_DIFF test"
    beautifyOptionPrint "l2" "Liquibase update:" "mvn liquibase:update liquibase:diff"
    beautifyOptionPrint "l3" "Liquibase process:" "liquibase-changelog-master.yml"
    beautifyOptionPrint "l4" "Liquibase verify:" "mvn -PLIQUIBASE_VERIFY test"
    beautifyOptionPrint "l5" "Create Local DB:" "$PROJECT_NAME" true

  elif [ "$PROJECT_TYPE" == "npm" ]; then
    beautifyOptionGroupTitlePrint "NPM Commands"
    beautifyOptionPrint "n1" "NPM Clean Install:" "npm ci"
    beautifyOptionPrint "n2" "NPM Start:" "npm run start"
    beautifyOptionPrint "n3" "NPM Test:" "npm run test"
    beautifyOptionPrint "n4" "NPM Test (Mocha):" "npm run test-mocha"
    beautifyOptionPrint "n5" "NPM Test (Pact):" "npm run test-pact"
    beautifyOptionPrint "n6" "NPM Test (Coverage):" "npm run test-coverage"
    beautifyOptionPrint "n7" "NPM Lint:" "npm run lint"
    beautifyOptionPrint "n8" "NPM Build:" "npm run build" true
  fi

  ############# Docker Commands #################
  beautifyOptionGroupTitlePrint "Docker Commands"
  beautifyOptionPrint "d1" "Docker" "Build"
  beautifyOptionPrint "d2" "Docker" "Push" true

  ############# Kubernetes Commands #############
  beautifyOptionGroupTitlePrint "Kubernetes Commands"
  beautifyOptionPrint "k1" "Kubernetes Service" "Upscale"
  beautifyOptionPrint "k2" "Kubernetes Service" "Downscale"
  beautifyOptionPrint "k3" "Kubernetes Service" "Restart"
  beautifyOptionPrint "k4" "Kubernetes Service" "Upscale all services"
  beautifyOptionPrint "k5" "Kubernetes Service" "Downscale all services"
  beautifyOptionPrint "k6" "Kubernetes Service" "Run Proxy"
  beautifyOptionPrint "k7" "Kubernetes Service" "Port Forward"
  beautifyOptionPrint "k8" "Kubernetes Service" "Debug Port Forward"
  beautifyOptionPrint "k9" "Kubernetes" "Generate Token" true

  ############## Git ############################
  beautifyOptionGroupTitlePrint "Gcloud Commands"
  beautifyOptionPrint "gc1" "Gcloud login" "gcloud auth login"
  beautifyOptionPrint "gc2" "Gcloud init" "gcloud init" true

  ############## Git ############################
  beautifyOptionGroupTitlePrint "Git Commands"
  beautifyOptionPrint "g1" "Git Fetch:" "git fetch"
  beautifyOptionPrint "g2" "Git Add All:" "git add ."
  beautifyOptionPrint "g3" "Git Add src folder:" "git add src/"
  beautifyOptionPrint "g4" "Git status:" "git status"
  beautifyOptionPrint "g5" "Git commit:" "git commit -m \$feature: \$message"
  beautifyOptionPrint "g6" "Git commit amend:" "git commit --amend --no-edit"
  beautifyOptionPrint "g7" "Git push:" "git push"
  beautifyOptionPrint "g8" "Git push Force With Lease:" "git push --force-with-lease"
  beautifyOptionPrint "g9" "Git squash n commits": "git rebase -i Head~n"
  beautifyOptionPrint "g10" "Git Rebase:" "git rebase origin/develop" true

  ############## Utility scripts ####################
  beautifyOptionGroupTitlePrint "Utilities"
  beautifyOptionPrint "u1" "Conversion" "Base64"
  beautifyOptionPrint "u2" "ping" "Utility"
  beautifyOptionPrint "c" "Custom command" "Run any command inside project path" true
  ############## Autopilot ######################
  beautifyOptionPrint "0" "Autopilot" "Mode" true

  ############ Settings Commands ################
  beautifyOptionGroupTitlePrint "Configs"
  beautifyOptionPrint "tl" "Toggle" "Logo" false "${LOGO_VIEW}"
  beautifyOptionPrint "tn" "Toggle" "Notification" false "${notification}"
  beautifyOptionPrint "s1" "Update" "Project Path." false "${PROJECT_PATH}"
  beautifyOptionPrint "s2" "Update" "Project Name." false "${PROJECT_NAME}"
  beautifyOptionPrint "s3" "Update" "Kubernetes Namespace." false "${NAMESPACE}"
  beautifyOptionPrint "s4" "Update" "Banner" false "${BANNER_PATH}"
  beautifyOptionPrint "s5" "Update" "Docker Pre Tag" false "${DOCKER_PRE_TAG}"
  beautifyOptionPrint "sr" "Update" "RabbitMQ Path" true "${RABBITMQ_PATH}"

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
pilotNavigation() {
  # shellcheck disable=SC2034
  TEMP_OPT=$1 # Used to highlight option later

  ########### Clear Screen And Print Chosen option #####
  echo "You picked option: ${BPURPLE} ${TEMP_OPT}${NC}. "

  case $TEMP_OPT in '0') autoPilot ;;

    ####### Maven Commands ################
  'm0') mavenAutoPilotSequence ;;
  'm1') mavenScriptCleanInstallWithoutTests ;;
  'm2') mavenScriptTest ;;
  'm3') mavenScriptCleanInstall ;;

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
  'l1') liquibaseScriptPrep ;;
  'l2') liquibaseScriptUpdate ;;
  'l3') liquibaseScriptProcess ;;
  'l4') liquibaseScriptVerify ;;
  'l5') liquibaseScriptRecreateLocalDB "$NAMESPACE" "$PROJECT_NAME";;

    ######## Docker Commands ###############
  'd1') dockerScriptBuild "${NAMESPACE}" "${PROJECT_NAME}" ;;
  'd2') dockerScriptPush "${NAMESPACE}" "${PROJECT_NAME}" ;;

    ######## Kubernetes Commands ###########
  'kr') kubeScriptRunRabbitmq ;;
  'k1') kubeScriptUpScale "${NAMESPACE}" "${PROJECT_NAME}-ms-deployment" ;;
  'k2') kubeScriptDownScale "${NAMESPACE}" "${PROJECT_NAME}-ms-deployment" ;;
  'k3') kubeScriptRestart "${NAMESPACE}" "${PROJECT_NAME}-ms-deployment" ;;
  'k4') kubeScriptScaleBatch "up" ;;
  'k5') kubeScriptScaleBatch ;;
  'k6') kubeScriptProxy ;;
  'k7') kubeScriptPortForward ;;
  'k8') kubeScriptPortForward "debug" ;;
  'k9') kubeScriptToken ;;

    ###### Gcloud commands ####################
  'gc1') gcloudScriptLogin ;;
  'gc2') gcloudScriptInit ;;

    ############### Git Commands #############
  'g1') gitScriptFetch ;;
  'g2') gitScriptAddAll ;;
  'g3') gitScriptAddSrc ;;
  'g4') gitScriptStatus ;;
  'g5') gitScriptCommit ;;
  'g6') gitScriptCommitAmend ;;
  'g7') gitScriptPush ;;
  'g8') gitScriptPushForceWithLease ;;
  'g9') gitScriptSquash ;;
  'g10') gitScriptRebase ;;

    ################### Utility Commands ##############
  'u1') utilBase64Conversion ;;
  'u2') pingUtility ;;
  'c') runCustomCommand ;;

    ####### Settings & Configs #############
  'tl') beautifyToggleLogo ;;
  'tn') notifyToggle ;;
  's1') projectPathUpdateForce ;;
  's2') projectNameUpdateForce ;;
  's3') kubeScriptNamespaceSetup 1 ;;
  's4') beautifyBannerUpdate ;;
  's5') kubeScripPreTagUpdate ;;
  'sr') kubeScriptSetRabbitmq ;;

    ####### Invalid option #############
  *) echo "Invalid command... Try again" ;;
  esac
}

# Initial cockpit drill
cockpitDrillInit() {
  dbInit
  notifyInit
  kubeScriptInit
  kubeScriptPreTagSetter
  projectPathSetup
  kubeScriptNamespaceSetup # inside kube_script
  liquibaseScriptInit
}

flightTakeOffAnnouncement() {
  utilScriptGreeting
}

resetVars() {
  liquibaseScriptReset
}

flightTakeOff() {
  while true; do
    ## Initiation
    resetVars
    beautifyLogoViewer # lOGO & Banner Viewer

    ## Process
    optionOutput         # Option Viewer
    optionInput          # Option Picker
    pilotNavigation "$opt" # And Command Execute

    ## End Process
    enterToContinue # Enter to Continue Template
  done
}


######## Main Function ##########

cockpitDrillInit

flightTakeOffAnnouncement

flightTakeOff
