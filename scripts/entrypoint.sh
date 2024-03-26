#!/usr/bin/env bash

BASE_PATH=$( dirname -- "$0" )
COMMAND="$1"

case $COMMAND in
  api)
    echo "Starting Clear My Record Entity Resolution API..."
    cd /opt/cmr
    bundle exec rackup --host 0.0.0.0 --port 3000
    ;;
  load)
    export CONFIG_FILE="/etc/cmr/config.yml"
    "$BASE_PATH/load.sh"
    ;;
  export)
    export CONFIG_FILE="/etc/cmr/config.yml"
    export INPUT_FILE="/etc/cmr/export/export.json"
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
