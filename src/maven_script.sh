#!/bin/bash

############ Maven Test ##############################
mavenTest() {
  commandPrintAndSave "mvn test" "validate"
}

################ Maven Clean Install #################
mavenCleanInstall() {
#  commandPrint "mvn clean install"
  commandPrintAndSave "mvn clean install" "validate"
}