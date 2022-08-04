#!/bin/bash
project_path=$1
liquibase_filepath="$project_path\target\liquibase-diff-changelog.yml"
echo "Liquibase file path: $liquibase_filepath"

old=(
	"VARCHAR(255)"
	"TEXT"
	"INT4"
	"INT8"
	"numeric(19, 2)"
	"numeric(12, 2)"
	"FLOAT8"
	"BYTEA"
	"date"
	"TIMESTAMPTZ"
	"now()"
	"BOOL"
	"true"
	"false"
	)

new=(
	"type.varchar"
	"type.clob"
	"type.int"
	"type.bigint"
	"type.bigint2"
	"type.money"
	"type.float"
	"type.blob"
	"type.date"
	"type.timestamp"
	"datetime.now"
	"boolean"
	"boolean.true"
	"boolean.false"
	)

for i in ${!old[@]}; do
	sed -i "s|type: ${old[$i]}|type: \"\${${new[$i]}}\"|g" $liquibase_filepath
	# sed -i "s|${old[$i]}|\"\${${new[$i]}}\"|g" $liquibase_filepath
done
# sed -i "s|$old|$new|g" $liquibase_filepath
