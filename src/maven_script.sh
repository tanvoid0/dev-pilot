#!/bin/bash

############ Maven Test ##############################
mavenTest() {
  commandPrint "mvn test"
}

################ Maven Clean Install #################
mavenCleanInstall() {
  commandPrint "mvn clean install"
}