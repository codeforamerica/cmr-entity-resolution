#!/usr/bin/env bash

FAILURE_COLOR="\033[1;31m"
SUCCESS_COLOR="\033[1;32m"
TEXT_COLOR="\033[1;34m"
NO_COLOR="\033[0m"

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

if [ -z "$CONFIG_FILE" ]; then
  echo -e "${FAILURE_COLOR}CONFIG_FILE is not set. Please set the CONFIG_FILE environment variable.${NO_COLOR}"
  exit 1
fi

echo "Config file: $CONFIG_FILE"

echo -e "${TEXT_COLOR}Importing records...${NO_COLOR}"
/opt/cmr/bin/importer import --config "$CONFIG_FILE"

exit_code=$?
if [ $exit_code -ne 0 ]; then
  echo -e "${FAILURE_COLOR}Import failed with code $exit_code${NO_COLOR}"
  exit $exit_code
fi

echo -e "${SUCCESS_COLOR}Import complete${NO_COLOR}"
