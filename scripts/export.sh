#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TEXT_COLOR="\033[1;34m"
NO_COLOR="\033[0m"

echo "Config file: $CONFIG_FILE"
echo "Input file : $INPUT_FILE"
echo "Output file: $OUTPUT_FILE"

# TODO: Use the API to export records.
PROJECT_NAME="export-$(date "+%Y-%m-%dT%H:%M")"
echo -e "${TEXT_COLOR}Creating project ${PROJECT_NAME}${NO_COLOR}"
G2CreateProject.py "$PROJECT_NAME"
source "$PROJECT_NAME/setupEnv"

# TODO: Is this the data source we want to use?
echo -e "${TEXT_COLOR}Exporting records${NO_COLOR}"
G2Export.py -o "$INPUT_FILE" -F json -x -f=0

echo -e "${TEXT_COLOR}Processing the export file${NO_COLOR}"
/opt/cmr/bin/postprocess process \
  --config "$CONFIG_FILE" \
  --input "$INPUT_FILE" \
  --output "$OUTPUT_FILE"

echo -e "${TEXT_COLOR}Export complete${NO_COLOR}"
