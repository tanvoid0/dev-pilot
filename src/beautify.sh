#!/bin/bash


########### Show Logo & Banner ###############
logoViewer() {
  ## Title Icon ######################
	echo -e "$Green"
	cat "$root_path/ascii/logo.ascii"
	echo -e "$NC"


	######## Banner #####################
  LOGO_VIEW="$(cat "${root_path}"/vars/logo.txt)"
  loadBanner

  if [ -z "$LOGO_VIEW" ]; then
    toggleBanner
  fi

	if [ "$LOGO_VIEW" == true ]; then
	  bannerPrinter "$BANNER_FILE"
	fi
}

############# Read and set banner ######################
loadBanner() {
  BANNER_FILE="$(cat "${root_path}"/vars/banner.txt)"
  if [ -z "$BANNER_FILE" ]; then
    bannerUpdate "cat/cat_moon"
  fi
}

bannerUpdate() {
  TEMP_VAL=$1
  echo "This can be confusing. to keep it simple, enter the relative path. e.g., if a file is in ${RED}/ascii/file.ascii${NC} enter ${RED}file${NC}"
  while [ -z "$TEMP_VAL" ]; do
      read -r -p "Enter relative path: " TEMP_VAL
  done
  BANNER_FILE=$TEMP_VAL

  echo "$BANNER_FILE" >"${root_path}/vars/banner.txt"
}

####### Show slayer ##############
bannerPrinter() {
  echo -e "$2"
  cat "$root_path/ascii/$1.ascii"
  echo -e "$NC"
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

commandPrintAndSave() {
  commandPrint "$1" | tee "$OUTPUT_FILE"

  if [ "$2" == "validate" ]; then
    cmdOutputResponseValidator
  fi
}


cmdOutputResponseValidator() {
  OUTPUT="$(cat "$OUTPUT_FILE")"
  printf "\n\n"

  OUTPUT_TRIM="${OUTPUT: -1000}"
  case "$OUTPUT_TRIM" in
    *"BUILD SUCCESS"*) bannerPrinter "jet_group" "${GREEN}" ; echo "${BGREEN}Operation completed Successfully${NC}..."; OUTPUT_RESPONSE=true ;;
    *"BUILD FAILED"*) bannerPrint "plane_crash" "${RED}" ; echo "${BRED}Operation failed${NC}..."; OUTPUT_RESPONSE=false ;;
    *) echo "Not sure... $OUTPUT_TRIM"; OUTPUT_RESPONSE="";;
  esac
}
