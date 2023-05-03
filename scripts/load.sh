#!/usr/bin/env bash

FAILURE_COLOR="\033[1;31m"
NO_COLOR="\033[0m"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SUCCESS_COLOR="\033[1;32m"
TEXT_COLOR="\033[1;34m"

echo "Config file: $CONFIG_FILE"
echo "Input file : $INPUT_FILE"
echo "Output file: $OUTPUT_FILE"

echo -e "${TEXT_COLOR}Processing the import file${NO_COLOR}"
/opt/cmr/bin/preprocess process \
  --config "$CONFIG_FILE" \
  --input "$INPUT_FILE" \
  --output "$OUTPUT_FILE"

exit_code=$?
if [ $exit_code -ne 0 ]; then
  echo -e "${FAILURE_COLOR}Processing failed with code $exit_code"
  exit $exit_code
fi

# TODO: Use the API to import records.
PROJECT_NAME="import-$(date "+%Y-%m-%dT%H:%M")"
echo -e "${TEXT_COLOR}Creating project ${PROJECT_NAME}${NO_COLOR}"
G2CreateProject.py "$PROJECT_NAME"
source "$PROJECT_NAME/setupEnv"

# TODO: Is this the data source we want to use?
echo -e "${TEXT_COLOR}Importing records${NO_COLOR}"
G2Loader.py -f "$OUTPUT_FILE/?data_source=PEOPLE,file_format=JSON"

exit_code=$?
if [ $exit_code -ne 0 ]; then
  echo -e "${FAILURE_COLOR}Import failed with code $exit_code"
  exit $exit_code
fi

echo -e "${SUCCESS_COLOR}Import complete${NO_COLOR}"
