#!/bin/bash
# @param1 title
# @param2 body
# @param3 icon

notifySend() {
   if [ "$notification" = "1" ]; then
        # shellcheck disable=SC2154
        "${root_path}/helper/notify-send" -i "$3" "$1" "$2"
    fi
}
#./notify-send -i error "Error" "File not found"
#./notify-send -i important "Warning!" "Update required"

notifyToggle(){
  if [ "$notification" == "1" ]; then
    notification="0"
    echo "Notifications ${BRED}Disabled${NC}"
  else
    notification="1"
    echo "Notifications ${BGREEN}Enabled${NC}"
  fi
  "$SQLITE_EXEC_PATH" "$DB_NAME" "UPDATE runtime_vars SET notification = '$notification' WHERE id=1;"
}

notifyInit() {
  notification=$("$SQLITE_EXEC_PATH" "$DB_NAME" "SELECT notification FROM runtime_vars")
  if [ "$notification" == "1" ]; then
      echo -e "Notification ${BRED}On${NC}\n"
  fi
}

