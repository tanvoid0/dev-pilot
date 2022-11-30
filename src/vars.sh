#!/bin/bash
######## Common vars to use across files ########

# Global Vars
TEST_VAR="Hello World"
OUTPUT_FILE="${root_path}/output.txt"                     # Output saved to file
OUTPUT_RESPONSE=""                                        # Output Response of a command
TEMP_OPT=""                                               # Option picked in main menu, used as automation bookmark
VAR_FILE_PATH="${root_path}/vars"                         # Cache variables
PROJECT_TYPE=""                                           # Type of Project
NAMESPACE=""                                              # Namespace
PROJECT_PATH=""                                           # Project Path
LOGO_VIEW=""                                              # Logo View Flag (boolean)
LOADER_TIMEOUT=5

## Autopilot vars
PILOT_LIQUIBASE_REQUIRED=""                               # defaults to false
DOCKER_PRE_TAG="eu.gcr.io/olm-rd/efm"                     # Docker Pre tag


# Colors
BLACK=$'\e[0;30m'
BBLACK=$'\e[0;30m'
RED=$'\e[0;31m'
BRED=$'\e[1;31m'
GREEN=$'\e[0;32m'
BGREEN=$'\e[1;32m'
YELLOW=$'\e[0;33m'
BYELLOW=$'\e[1;33m'
BLUE=$'\e[0;34m'
BBLUE=$'\e[1;34m'
PURPLE=$'\e[0;35m'
BPURPLE=$'\e[1;35m'
CYAN=$'\e[0;36m'
BCYAN=$'\e[1;36m'
WHITE=$'\e[0;37m'
BWHITE=$'\e[1;37m'

RED_HIGHLIGHT=$'\e[0;41m'
YELLOW_HIGHLIGHT=$'\e[0;103m'

NC=$'\e[0m'

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White
