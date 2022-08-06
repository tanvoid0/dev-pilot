#!/bin/bash
## Script to run port forward
# @param1 namespace
# @param2 service
HOST_PORT=7000
REMOTE_PORT=80

if [ "$3" == "debug" ]; then
  HOST_PORT=7001
  REMOTE_PORT=81
fi
npx kill-port HOST_PORT

kubectl --n "${1}" port-forward svc/"${2}"-service "${HOST_PORT}":"${REMOTE_PORT}"
