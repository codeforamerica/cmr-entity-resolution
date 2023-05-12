#!/usr/bin/env bash

FAILURE_COLOR="\033[1;31m"
NO_COLOR="\033[0m"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SUCCESS_COLOR="\033[1;32m"
TEXT_COLOR="\033[1;34m"

echo "Config file: $CONFIG_FILE"

echo -e "${TEXT_COLOR}Importing records${NO_COLOR}"
/opt/cmr/bin/importer import --config "$CONFIG_FILE"

exit_code=$?
if [ $exit_code -ne 0 ]; then
  echo -e "${FAILURE_COLOR}Import failed with code $exit_code"
  exit $exit_code
fi

echo -e "${SUCCESS_COLOR}Import complete${NO_COLOR}"
