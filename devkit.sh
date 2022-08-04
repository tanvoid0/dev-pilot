#!/bin/bash

# Input Project Data section
project_path="D:\Workspace\microservices\payment"
root_path=$( pwd )
# if [ -z $1 ]; then
# 	read -p "Enter Project path: " project_path
# else
# 	project_path=$1
# fi

: '
List of commands
'

commands=(
	"mvn clean install" "mvn test" 
	"mvn -PLIQUIBASE_PREPARE_FOR_DIFF test" 
	"mvn liquibase:update liquibase:diff" 
	"Replace Liquibase.yml properties" 
	"mvn -PLIQUIBASE_VERIFY test" 
	"echo Hello World")


: '
Read a file line by line
'
readFile() {
	while IFS= read -r line; do
		echo $line
	done < $liquibase_filepath
}

: '
Dummy decorator for "Press Enter"
'
enterToConinue(){
	printf "\n"
	read -n 1 -s -r -p $"Press Enter (⏎) to continue..."
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
	echo "Liquibase Exterminator.."
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
		echo "$((i+1)). Run \"${commands[$i]}\""
	done
	echo "0. Autopilot Mode"
	printf "\n"
	echo "Ctrl + C (^C) to quite..."
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
	echo "Running command: \"${cmnd}\""
	\
	case $1 in 5) $root_path/liquibase-script.sh $project_path;;
	0) echo "Sorry to dissappoint you! Still working on it!";;
	*) $cmnd;;
	esac

	# case $choice in  0) echo "Option 0";;
	# 	1) echo "Option 1";;
	# 	2) echo "Option 2";;
	# 	3) echo "Option 3";;
	# 	echo "Default";;
	# esac
	

	# if [[ $choice -eq 4 ]]; then
	# 	liquibaseYamlPropertyReplace
	# else
	# 	output=$( $cmnd )
	# fi
	# echo "Output: ${output:0:20}"

}


: '
Main functions
'
option=-1
# while [ $option != 0 ]
while [ true ]
do
	optionPicker
	optionExecutor $option
	enterToConinue

done