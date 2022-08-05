#!/bin/bash

# Input Project Data section
project_path="D:\Workspace\microservices\payment"
root_path=$( pwd )
logo=true
# if [ -z $1 ]; then
# 	read -p "Enter Project path: " project_path
# else
# 	project_path=$1
# fi

GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
BRED=$'\e[1;31m'
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

: '
List of commands
'

commands=(
	"mvn clean install" "mvn test" 
	"mvn -PLIQUIBASE_PREPARE_FOR_DIFF test" 
	"mvn liquibase:update liquibase:diff" 
	"Replace Liquibase.yml properties" 
	"mvn -PLIQUIBASE_VERIFY test" 
	# "echo Hello World"
	)

: '
Show Logo & Icon
'
logoViewer() {
	echo -e "$Green"
	cat "$root_path\\ascii\\logo.ascii" 
	echo -e "$NC"
	if [ $logo == true ]; then
		echo -e "$Red"
		cat "$root_path\\ascii\\robot.ascii"
		echo -e "$NC"
	fi
}

: '
Toggle Icon
'
toggleIcon() {

	if [ $logo == true ]; then
		echo "Icon ${RED}Disabled${NC}"
		logo=false;
	else
		echo "Icon ${GREEN}Enabled${NC}"
		logo=true;
	fi
}

: '
Read a file line by line
'
readFile() {
	while IFS= read -r line; do
		echo $line
	done < $1
}

: '
Dummy decorator for "Press Enter"
'
enterToConinue(){
	printf "\n"
	read -n 1 -s -r -p $"Press ${RED}Enter (⏎)${NC} to continue..."
	printf "\033c"
}

: '
Input for Project Path
'
readProjectPath() {
	read -p "Enter project path: " project_path
}

: '
Check if Maven Project
'
projectChecker() {
	cd $project_path
	pwd

	pom_file_location="${project_path}/pom.xml"
	if [ -f "$pom_file_location" ]; then
		echo ""
	else
		echo "Invalid project path"
		readProjectPath
		return
	fi
	printf "\n"
}


: '
Command Picker
'
optionPicker() {
	projectChecker

	for i in ${!commands[@]}; do
		echo "${RED}$((i+1)).${NC} Run \"${GREEN}${commands[$i]}${NC}\""
	done
	echo "${RED}x.${NC} Toggle LOGO"
	echo "${RED}0.${NC} Autopilot Mode"
	printf "\n"
	echo "Press ${BRED}Ctrl+C${NC} to quite..."
	printf "\n"

	read -p "Enter an option: " option
	printf "\n"
}


: '
Execution of commands
'
optionExecutor() {
	opt=$1
	opt=$((opt-1))
	cmnd=${commands[$opt]}

	output=""
	# echo "${RED}Running command:${NC} \"${cmnd}\""
	\
	case $1 in 0) echo "Sorry to dissappoint you! Still working on it!";;
	5) $root_path/helper-scripts/liquibase-script.sh $project_path;;
	x) toggleIcon;;
	*) $cmnd;;
	esac

}

: '
Main functions
'
option=-1
# while [ $option != 0 ]
while [ true ]
do
	logoViewer
	optionPicker
	optionExecutor $option
	enterToConinue
done