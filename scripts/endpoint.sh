#!/usr/bin/env bash

BASE_PATH=$( dirname -- "$0" )
COMMAND=${1}

case $COMMAND in
  load)
    export CONFIG_FILE="/etc/cmr/config.yml"
    export INPUT_FILE="/etc/cmr/imports/import.json"
    export OUTPUT_FILE="/etc/cmr/imports/import.csv"
    "$BASE_PATH/load.sh"
    ;;
  export)
    export CONFIG_FILE="/etc/cmr/config.yml"
    export INPUT_FILE="/etc/cm/exports/export.json"
    export OUTPUT_FILE="/etc/cmr/exports/people.csv"
    "$BASE_PATH/export.sh"
    ;;
  run)
    echo "Your CMR container is now running..."
    tail -f /dev/null
    ;;
  *)
    echo "Invalid command \"$COMMAND\""
    exit 127
    ;;
esac
