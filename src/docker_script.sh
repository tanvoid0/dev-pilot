#!/bin/bash
# # Put credentials below

#### Docker Commands ##########
# @param1 action
# @param2 namespace
# @param3 project_name
#
# @action build
#     Build Docker Image
# @action push
#     Push Docker Image

dockerScriptBuild() {
  echo "${GREEN}Building${NC} docker image for ${RED}project ${2}${NC}"
  commandPrintAndSave "docker build --network=host --tag ${DOCKER_PRE_TAG}/${2}:${1} ."
}

dockerScriptPush() {
  echo "${GREEN}Pushing${NC} ${RED}${2}${NC} docker image to cloud..."
  commandPrintAndSave "docker push ${DOCKER_PRE_TAG}/${2}:${1}"
}

dockerRunningValidator() {
  commandPrintAndSave "docker version" # TODO: Fix docker not running message not being captured, thus unable to test"validate" "" "docker daemon is not running"
}

autoPilotDocker() {
  #  autoPilotFlyMode 'd1' true
  autoPilotFlyMode 'd2' false # TODO: Create proper validation process for docker
  autoPilotFlyMode 'd3' false # TODO: Create proper validation process for docker
}

