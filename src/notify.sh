#!/bin/bash
# @param1 title
# @param2 body
# @param3 icon

notifySend() {
  # shellcheck disable=SC2154
  "${root_path}/helper/notify-send" -i "$3" "$1" "$2"
}
#./notify-send -i error "Error" "File not found"
#./notify-send -i important "Warning!" "Update required"