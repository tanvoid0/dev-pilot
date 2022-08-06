#!/bin/bash


########### Show Logo & Banner ###############
logoViewer() {
  ## Title Icon ######################
	echo -e "$Green"
	cat "$root_path/ascii/logo.ascii"
	echo -e "$NC"


	######## Banner #####################
  LOGO_VIEW="$(cat "${root_path}"/vars/logo.txt)"
  if [ -z "$LOGO_VIEW" ]; then
    toggleBanner
  fi

	if [ "$LOGO_VIEW" == true ]; then
		echo -e "$Red"
		cat "$root_path/ascii/robot.ascii"
		echo -e "$NC"
	fi
}


############### ToggleBanner ##################
toggleBanner() {
	if [ "$LOGO_VIEW" == true ]; then
		echo "Icon ${RED}Disabled${NC}"
		LOGO_VIEW=false;
	else
		echo "Icon ${GREEN}Enabled${NC}"
		LOGO_VIEW=true;
	fi
	echo "$LOGO_VIEW" > "${root_path}/vars/logo.txt"
}

######## Dummy decorator for "Press Enter" ########
enterToContinue(){
	printf "\n"
	read -n 1 -s -r -p $"Press ${RED}Enter (⏎)${NC} to continue..."
	printf "\033c"
}

########## Highlight Color for Previous Picked Option #########
highlightOption(){
  NON_HIGHLIGHT_COLOR="${RED}"
  HIGHLIGHT_COLOR="${RED_HIGHLIGHT}"
  if [ "$TEMP_OPT" == "$1" ]; then
      OPT_COLOR="${HIGHLIGHT_COLOR}"
  else
      # shellcheck disable=SC2034
      OPT_COLOR="${NON_HIGHLIGHT_COLOR}"
  fi
}

######### Beautify Option Group title #################
optionGroupTitlePrint() {
  echo "${PURPLE} $1 ${NC}"
}

########## Beautify and Print Option #########
optionPrint() {
  highlightOption "$1"
  printf "%s%4s.%s %s %s%s%s " "${OPT_COLOR}" "${1}" "${NC}" "${2}" "${BGREEN}" "${3}" "${NC}"
  if [[ -n "$5" ]]; then
     echo -n "Current: ${BYELLOW}${5}${NC}"
  fi
  printf "\n"
  if [ "$4" == true ]; then
    printf "\n"
  fi
}


############ Beautify and print Command #########
commandPrint() {
  echo "Running command: ${BYELLOW}$1${NC}"
  sleep 1.4s
  printf "\n"
  eval "$1"
}