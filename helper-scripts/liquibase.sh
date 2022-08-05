#!/bin/bash
project_path=$1
liquibase_filepath="$project_path/target/liquibase-diff-changelog.yml"
echo "Liquibase file path: $liquibase_filepath"

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

read -p "Enter new liquibase file title: " filename
db_changelog_path="${project_path}/src/main/resources/db/changelog"

liquibase_new_filepath="$db_changelog_path/$filename.yml"
# echo "Old path: $liquibase_filepath, new path: $liquibase_new_filepath"

cp "$liquibase_filepath" "$liquibase_new_filepath"

for i in ${!old[@]}; do
	sed -i "s|type: ${old[$i]}|type: \"\${${new[$i]}}\"|g" $liquibase_new_filepath
done
# sed -i "s|$old|$new|g" $liquibase_filepath

## Append to liquibase-
master_liquibase="$db_changelog_path/liquibase-changelog-master.yml"
# echo "$master_liquibase"
echo  -e "\n  - include:\n      file: $filename.yml\n      relativeToChangelogFile: true\n" >> $master_liquibase

# echo "File moved to $liquibase_new_filepath"