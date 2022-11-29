#!/bin/bash

############ Maven Test ##############################
mavenScriptTest() {
  commandPrintAndSave "mvn test" "validate"
}

################ Maven Clean Install #################
mavenScriptCleanInstall() {
#  commandPrint "mvn clean install"
  commandPrintAndSave "mvn clean install $1" "validate" "docker daemon is not running."
}

mavenScriptCleanInstallWithoutTests() {
  mavenScriptCleanInstall "-DskipTests=true"
}

mavenAutoPilotSequence() {
#  liquibaseScriptAutoPilotInit
  autoPilotFlyMode 'm2'
  autoPilotFlyMode 'm3'
#  liquibaseScriptAutoPilot
}