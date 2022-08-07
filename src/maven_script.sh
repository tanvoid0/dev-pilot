#!/bin/bash

############ Maven Test ##############################
mavenTest() {
  commandPrintAndSave "mvn test" "validate"
}

################ Maven Clean Install #################
mavenCleanInstall() {
#  commandPrint "mvn clean install"
  commandPrintAndSave "mvn clean install" "validate" "docker daemon is not running."
}

autoPilotMaven() {
  autoPilotFlyMode 'm1'
  autoPilotFlyMode 'm2'
}