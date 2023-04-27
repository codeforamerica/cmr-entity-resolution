#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TEXT_COLOR="\033[1;34m"
NO_COLOR="\033[0m"

echo "Config file: $CONFIG_FILE"
echo "Input file : $INPUT_FILE"
echo "Output file: $OUTPUT_FILE"

echo -e "${TEXT_COLOR}Processing the import file${NO_COLOR}"
/opt/cmr/bin/preprocess process \
  --config "$CONFIG_FILE" \
  --input "$INPUT_FILE" \
  --output "$OUTPUT_FILE"

# TODO: Use the API to import records.
echo -e "${TEXT_COLOR}Creating project${NO_COLOR}"
PROJECT_NAME="import-$(date "+%Y-%m-%dT%H:%M")"
G2CreateProject.py "$PROJECT_NAME"
source "$PROJECT_NAME/setupEnv"

# TODO: Is this the data source we want to use?
echo -e "${TEXT_COLOR}Importing records${NO_COLOR}"
G2Loader.py -f "$OUTPUT_FILE/?data_source=PEOPLE,file_format=JSON"
