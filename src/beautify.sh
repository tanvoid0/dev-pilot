#!/bin/bash

########### Show Logo & Banner ###############
beautifyLogoViewer() {
  ## Title Icon ######################

  beautifyLoadLogo
  beautifyLoadBanner
}

############# Read and set Logo #########################
beautifyLoadLogo() {
  	LOGO_VIEW=$("$SQLITE_EXEC_PATH" "$DB_NAME" "SELECT logo_view FROM runtime_vars")
  	if [ "$LOGO_VIEW" == "true" ]; then
    	  bannerPrinter "logo" "$GREEN"
    fi
}

############## Read and set banner ######################
beautifyLoadBanner() {
  BANNER_PATH=$("$SQLITE_EXEC_PATH" "$DB_NAME" "SELECT banner_path FROM runtime_vars")
  bannerPrinter $BANNER_PATH "$RED"
}

beautifyBannerUpdate() {
  input=""
  while [ -z "$input" ]; do
      read -r -p "Enter relative path to ascii folder: " input
      banner_file_location="${root_path}/ascii/${input}.ascii"
      if [ -f "$banner_file_location" ]; then
        BANNER_PATH="$input"
        "$SQLITE_EXEC_PATH" "$DB_NAME" "UPDATE runtime_vars SET banner_path='$input' WHERE id=1"
        echo "Banner Relative Path set to: ${BRED}${input}${NC}"
        break;
      else
        echo -e "${BRED}Invalid relative file path...${NC} the file ${BYELLOW}'${banner_file_location}${NC} does not exist. Please try again.\n"
        input=""
      fi
  done
  BANNER_PATH=$TEMP_VAL
}

####### Show Banner ##############
bannerPrinter() {
  echo -e "${2}"
  cat "${root_path}/ascii/${1}.ascii"
  echo -e "${NC}"
}


############### ToggleBanner ##################
beautifyToggleLogo() {
	if [ "$LOGO_VIEW" == "true" ]; then
		echo "Logo ${RED}Disabled${NC}"
		LOGO_VIEW="false";
	else
		echo "Logo ${GREEN}Enabled${NC}"
		LOGO_VIEW="true";
	fi
	"$SQLITE_EXEC_PATH" "$DB_NAME" "UPDATE runtime_vars SET logo_view='${LOGO_VIEW}' WHERE id=1;"
}

######## Dummy decorator for "Press Enter" ########
enterToContinue(){
	printf "\n"
	read -n 1 -s -r -p $"Press ${RED}Enter (⏎)${NC} to continue..."
	printf "\033c"
}

########## Highlight Color for Previous Picked Option #########
beautifyHighlightOption(){
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
beautifyOptionGroupTitlePrint() {
  echo "${PURPLE} $1 ${NC}"
}

########## Beautify and Print Option #########
beautifyOptionPrint() {
  beautifyHighlightOption "$1"
  printf "%s%4s.%s %s %s%s%s " "${OPT_COLOR}" "${1}" "${NC}" "${2}" "${BGREEN}" "${3}" "${NC}"
  if [[ -n "$5" ]]; then
     echo -n "Current: ${BYELLOW}${5}${NC}"
  fi
  printf "\n"
  if [ "$4" == true ]; then
    printf "\n"
  fi
}

beautifyClearScreen() {
  printf "\033c"
}