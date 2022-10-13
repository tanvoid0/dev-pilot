#!/bin/bash
# @param1 title
# @param2 body
# @param3 icon

notifySend() {
   if [ "$NOTIFICATION_SENDER" = "true" ]; then
        echo "Notify Send got ${root_path} $1 $2 $3"
        # shellcheck disable=SC2154
        "${root_path}/helper/notify-send" -i "$3" "$1" "$2"
        echo "Event sent";
    fi
}
#./notify-send -i error "Error" "File not found"
#./notify-send -i important "Warning!" "Update required"