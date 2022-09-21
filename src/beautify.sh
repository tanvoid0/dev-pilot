#!/bin/bash

########### Show Logo & Banner ###############
beautifyLogoViewer() {
  ## Title Icon ######################
	echo -e "$Green"
	cat "$root_path/ascii/logo.ascii"
	echo -e "$NC"


	######## Banner #####################
	LOGO_VIEW=$("$SQLITE_EXEC_PATH" "$DB_NAME" "SELECT logo_view FROM runtime_vars")
  beautifyLoadBanner

  if [ -z "$LOGO_VIEW" ]; then
    beautifyToggleBanner
  fi

	if [ "$LOGO_VIEW" == "true" ]; then
	  bannerPrinter "$BANNER_FILE"
	fi
}

############# Read and set banner ######################
beautifyLoadBanner() {
  BANNER_FILE="$(cat "${VAR_FILE_PATH}"/banner.txt)"
  if [ -z "$BANNER_FILE" ]; then
    beautifyBannerUpdate "cat/cat_moon"
  fi
}

beautifyBannerUpdate() {
  TEMP_VAL=$1
  if [ -n "$BANNER_FILE" ]; then
    echo "This can be confusing. to keep it simple, enter the relative path. e.g., if a file is in ${RED}/ascii/file.ascii${NC} enter ${RED}file${NC}"
  fi
  while [ -z "$TEMP_VAL" ]; do
      read -r -p "Enter relative path: " TEMP_VAL
  done
  BANNER_FILE=$TEMP_VAL

  echo "$BANNER_FILE" >"${VAR_FILE_PATH}/banner.txt"
}

####### Show slayer ##############
bannerPrinter() {
  echo -e "$2"
  cat "$root_path/ascii/$1.ascii"
  echo -e "$NC"
}


############### ToggleBanner ##################
beautifyToggleBanner() {
	if [ "$LOGO_VIEW" == "true" ]; then
		echo "Icon ${RED}Disabled${NC}"
		LOGO_VIEW="false";
	else
		echo "Icon ${GREEN}Enabled${NC}"
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


############ Beautify and print Command #########
commandPrint() {
  echo "Running command: ${BYELLOW}$1${NC}"
  printf "\n"
  eval "$1"
}

commandPrintAndSave() {
  notifySend "Command Running" "$1"
  commandPrint "$1" | tee "$OUTPUT_FILE"

  if [ "$2" == "validate" ]; then
    cmdOutputResponseValidator "$3" "$4"
  fi
}


cmdOutputResponseValidator() {
  OUTPUT="$(cat "$OUTPUT_FILE")"
  SUCCESS_STRING="$1"
  FAILED_STRING="$2"
  if [ -z "$SUCCESS_STRING" ]; then
    SUCCESS_STRING="BUILD SUCCESS"
  fi

  if [ -z "$FAILED_STRING" ]; then
    FAILED_STRING="BUILD FAILED"
  fi

  OUTPUT_TRIM="${OUTPUT: -1500}"
  case "$OUTPUT_TRIM" in
    *"$SUCCESS_STRING"*) bannerPrinter "jet_group" "${GREEN}" ; echo "${BGREEN}Operation completed Successfully${NC}..."; OUTPUT_RESPONSE=true; notifySend "Success" "Command finished successfully" ;;
    *"$FAILED_STRING"*) bannerPrint "plane_crash" "${RED}" ; echo "${BRED}Operation failed${NC}..."; OUTPUT_RESPONSE=false; notifySend "Failure" "Command failed." error ;;
    *) echo "Not sure... $OUTPUT_TRIM"; OUTPUT_RESPONSE="";;
  esac
}