#!/bin/bash

DB_NAME="${root_path}/db.sqlite"
SQLITE_EXEC_PATH="${root_path}/src/script/win/sqlite/sqlite3"

#INSERT_INTO_PROJECT="INSERT INTO project (project_path, project_name) VALUES ('path', 'name');";

#VIEW_PROJECT="SELECT * FROM project;"

######### Execute a query ########
dbExecQuery() {
  echo "Executing SQL Query: \"$1\""
  "$SQLITE_EXEC_PATH" "$DB_NAME" "$1"
}

####### Create table if doesn't exist ########
#dbCreateTableIfDoesntExist() {
#  DB_INIT="$SQLITE_EXEC_PATH" "$DB_DB_NAME" "SELECT * FROM runtime_vars;";
#
##  echo "DB_INIT VALUE: $DB_INIT";
#
#  if [ -z "$DB_INIT" ]; then
#     "$SQLITE_EXEC_PATH" "$DB_NAME" "$(cat "$root_path/query.sql")":
#  fi
#}

#dbDropAndCreateTable() {
#  dbExecQuery "DROP TABLE IF EXISTS cloud;"
#  dbExecQuery "DROP TABLE IF EXISTS project;"
#  dbExecQuery "DROP TABLE IF EXISTS runtime_vars;"
#  dbCreateTableIfDoesntExist
#}

#### INSERT Command
# 1. tablename
# 2. columnnames
# 3. values
dbInsert() {
  "$SQLITE_EXEC_PATH" "$DB_DB_NAME" "INSERT INTO $1 ($2) VALUES($3)";
}

# 1. tablename
# 2. Column names
dbView() {
  dbExecQuery "SELECT $2 FROM $1";
}

# 1. Table (project)
# 2. Values (column1=newval, column2=newval2)
# 3. Condition(id=1)
dbUpdate() {
  dbExecQuery "UPDATE $1 SET $2 WHERE $3"
}

dbMockCopier() {
  if [ -f "$DB_NAME" ]; then
    FIRST_SETUP=false
    return
  else
    FIRST_SETUP=true
#    cat > "$DB_NAME"
#    cp "$root_path/db.sqlite.example" "$DB_NAME"
    cat "$root_path/query.sql" | "$SQLITE_EXEC_PATH" "$DB_NAME"
  fi
}

dbInit() {
#  rm "$root_path/db.sqlite";
#  dbCreateTableIfDoesntExist
#  dbDropAndCreateTable
#  dbView "project" "*"
  dbMockCopier
}
