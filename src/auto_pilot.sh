############ Auto pilot ####################
autoPilot() {
  bannerPrinter "flight_take_off" "${GREEN}"
  echo "Auto pilot mode ${RED}Deployed ✈ ${NC} ..."
  sleep 1s
  OUTPUT_RESPONSE=true

  if [ "$PROJECT_TYPE" == "maven" ]; then
    liquibaseScriptAutoPilotSequence
    mavenAutoPilotSequence
  elif [ "$PROJECT_TYPE" == "npm" ]; then
    autoPilotNpm
  else
    echo "Invalid Project Type. Can't take off for flight..."
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
    pilotNavigation "$1"
  fi
}

autoPilotNpm() {
  echo "The feature is still ${RED}under testing${NC}... Thank you for your patience..."
}

autoPilotMaven() {
  autoPilotMavenSequence

  autoPilotLiquibase
  autoPilotDocker
  autoPilotKubernetes

  autoPilotLand
}

autoPilotLand() {
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