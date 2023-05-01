# Destinations

When exporting data from Senzing, you can configure the destination for the
resulting data. This data will be run through the postprocessor prior to being
written to the destination.

## Common configuration options

| Option          | Default | Required | Description                                                                          |
|-----------------|---------|----------|--------------------------------------------------------------------------------------|
| type            |         | YES      | The type of destination to use. Should be the name of one of the destinations below. |
| export_file[^1] |         | YES      | Path to the JSON export from Senzing.                                                |

## JSONL

Write records to a [JSON Lines][jsonl] formatted file. Each record will be
written as a single JSON object each on their own line.

### Configuration

The following options are available for this destination.

| Option    | Default | Required | Description                                             |
|-----------|---------|----------|---------------------------------------------------------|
| path      |         | YES      | The path to write the JSONL file.                       |
| overwrite | false   | NO       | Overwrite the existing file instead of appending to it. |

## CSV

Write records to a CSV file with optional headers.

### Configuration

The following options are available for this destination.

| Option    | Default | Required | Description                                             |
|-----------|---------|----------|---------------------------------------------------------|
| path      |         | YES      | The path to write the JSONL file.                       |
| overwrite | false   | NO       | Overwrite the existing file instead of appending to it. |
| headers   | [ ]     | NO       | List of headers to write to the CSV file.               |

[jsonl]: https://jsonlines.org/
[^1]: Use of an export file is temporary until records can be exported directly
using the API.
