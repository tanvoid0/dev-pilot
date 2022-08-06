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
  echo "Running command: ${GREEN}mvn -PLIQUIBASE_VERIFY test%s${NC}"
  printf "\n\n"
  sleep 2s
  mvn -PLIQUIBASE_VERIFY test
  sleep 5s
}

################## Extension of `prepareLiquibase()` #################################
processLiquibase() {
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
  sleep 10s
}

############## Prepare Liquibase Database ##################
prepareLiquibase() {

  ################### New Liquibase Change File Name ###########
  read -r -p "Enter new liquibase file title: " liquibase_filename

  ############ Initialize filepath #################
  # db_changelog_path - The database changelog directory path in the source directory of the project
  # liquibase_filepath - generated file path of liquibase
  # master_liquibase - The liquibase-changelog-master file path
  # liquibase_new_filepath - The newly generated liquibase changes file path with new types
  db_changelog_path="${1}/src/main/resources/db/changelog"
  liquibase_filepath="${1}/target/liquibase-diff-changelog.yml"
  master_liquibase="$db_changelog_path/liquibase-changelog-master.yml"
  liquibase_new_filepath="$db_changelog_path/$liquibase_filename.yml"

  commandPrint "mvn -PLIQUIBASE_PREPARE_FOR_DIFF test"
  printf "\033c"

  commandPrint "mvn liquibase:update liquibase:diff"
  printf "\033c"
  printf "\n\nLiquibase file tested and generated successfully. Processing your liquibase file and copying to resources..."
  sleep 2s
  processLiquibase
}