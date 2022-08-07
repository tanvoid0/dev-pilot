#!/bin/bash
old=(
	"varchar(255)"
	"VARCHAR(255)"
	"TEXT"
	"INTEGER"
	"INT4"
	"INT8"
	"BIGINT"
	"bigint"
	"BIGSERIAL"
	"numeric(19, 2)"
	"numeric(12, 2)"
	"float4"
	"FLOAT8"
	"BYTEA"
	"date"
	"TIMESTAMPTZ"
	"TIMESTAMP WITH TIME ZONE"
	"now()"
	"BOOL"
	"true"
	"false"
	)

new=(
	"type.varchar"
	"type.varchar"
	"type.clob"
	"type.int"
	"type.int"
	"type.bigint"
	"type.bigint"
	"type.bigint"
	"type.bigint"
	"type.bigint2"
	"type.money"
	"type.float"
	"type.float"
	"type.blob"
	"type.date"
	"type.timestamp"
	"type.timestamp"
	"datetime.now"
	"boolean"
	"boolean.true"
	"boolean.false"
	)

## TODO: Generate Database for initial database creation #####
# param1: namespace
# param2: service-name
generateLocalDatabaseQuery() {
  echo "create database \"$2-$1\" template template0 encoding UTF8 lc_collate 'en_GB.UTF-8' lc_ctype 'en_GB.UTF-8';"
}


## Common vars to use across functions
db_changelog_path=""
liquibase_filename=""
liquibase_filepath=""
liquibase_new_filepath=""

################ Validate Liquibase Changelog #######################
validateLiquibase() {
  commandPrintAndSave "mvn -PLIQUIBASE_VERIFY test" "validate"
}

################## Extension of `prepareLiquibase()` #################################
processLiquibase() {
  if [ -z "$liquibase_filename" ]; then
    liquibaseSetFilename
  fi

  ## Copy Generated Liquibase file to resources ###
  commandPrint "cp \"$liquibase_filepath\" \"$liquibase_new_filepath\""

  printf "\n"
  ### Replace Types with expected types ###
  for i in "${!old[@]}"; do
  	commandPrint "sed -i \"s|type: ${old[$i]}|type: \"\${${new[$i]}}\"|g\" \"$liquibase_new_filepath\""
  done

  ### Add new file name to liquibase-changelog-master.yml ###
  printf "\n"
  commandPrint "echo  -e \"\n  - include:\n      file: $liquibase_filename.yml\n      relativeToChangelogFile: true\n\" >> \"$master_liquibase\""
  printf "\n"

  printf "Your resources folder has been updated. Please revalidate the liquibase changes in %s...\n" "${liquibase_new_filepath}"

  if [ "$PILOT_LIQUIBASE_REQUIRED" == true ]; then
    echo "Once you are happy with the liquibase changes, you can continue rest of the autopilot mode.."
    notifySend "Action Required" "Liquibase File Generated..." important
    enterToContinue
  fi
}

############## Prepare Liquibase Database ##################
prepareLiquibase() {
  prepareLiquibaseForInitialTest
  prepareLiquibaseForDiff
}

prepareLiquibaseForDiff() {
  commandPrintAndSave "mvn liquibase:update liquibase:diff" "validate"
}

prepareLiquibaseForInitialTest() {
  commandPrintAndSave "mvn -PLIQUIBASE_PREPARE_FOR_DIFF test" "validate"
}

liquibaseScriptReset() {
  liquibase_filename=""
  liquibase_new_filepath=""
  PILOT_LIQUIBASE_REQUIRED=false
}

################### New Liquibase Change File Name ###########
# liquibase_new_filepath - The newly generated liquibase changes file path with new types
liquibaseSetFilename() {
  liquibase_filename=""
  while [ -z "$liquibase_filename" ]; do
      read -r -p "Enter new liquibase file title: " liquibase_filename
  done
  liquibase_new_filepath="$db_changelog_path/$liquibase_filename.yml"
}

############ Initialize filepath #################
# db_changelog_path - The database changelog directory path in the source directory of the project
# liquibase_filepath - generated file path of liquibase
# master_liquibase - The liquibase-changelog-master file path
initLiquibasePaths() {
  db_changelog_path="$PROJECT_PATH/src/main/resources/db/changelog"
  liquibase_filepath="$PROJECT_PATH/target/liquibase-diff-changelog.yml"
  master_liquibase="$db_changelog_path/liquibase-changelog-master.yml"
}

autoPilotLiquibasePrep() {
  read -r -p "Do you need liquibase for this flight? (y/n): " PILOT_LIQUIBASE_REQUIRED
  if [ "$PILOT_LIQUIBASE_REQUIRED" == "y" ] || [ "$PILOT_LIQUIBASE_REQUIRED" == "Y" ]
  then
    PILOT_LIQUIBASE_REQUIRED=true
    liquibaseSetFilename
  else
    PILOT_LIQUIBASE_REQUIRED=false
  fi
}

autoPilotLiquibase() {
  if [ "$PILOT_LIQUIBASE_REQUIRED" == true ]; then
    autoPilotFlyMode 'l1'
    autoPilotFlyMode 'l2'
    autoPilotFlyMode 'l3'
    autoPilotFlyMode 'l4'
  fi
}