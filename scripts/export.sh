#!/usr/bin/env bash

FAILURE_COLOR="\033[1;31m"
NO_COLOR="\033[0m"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SUCCESS_COLOR="\033[1;32m"
TEXT_COLOR="\033[1;34m"

echo "Config file: $CONFIG_FILE"
echo "Input file : $INPUT_FILE"

# TODO: Use the API to export records.
PROJECT_NAME="export-$(date "+%Y-%m-%dT%H:%M")"
echo -e "${TEXT_COLOR}Creating project ${PROJECT_NAME}${NO_COLOR}"
G2CreateProject.py "$PROJECT_NAME"
source "$PROJECT_NAME/setupEnv"

# TODO: Is this the data source we want to use?
echo -e "${TEXT_COLOR}Exporting records${NO_COLOR}"
G2Export.py -o "$INPUT_FILE" -F json -x -f=0

echo -e "${TEXT_COLOR}Sending records to destination${NO_COLOR}"
/opt/cmr/bin/exporter export \
  --config "$CONFIG_FILE"

exit_code=$?
if [ $exit_code -ne 0 ]; then
  echo -e "${FAILURE_COLOR}Export failed with code $exit_code"
  exit $exit_code
fi

echo -e "${SUCCESS_COLOR}Export complete${NO_COLOR}"
