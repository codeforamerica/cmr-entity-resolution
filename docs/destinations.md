# Destinations

When exporting data from Senzing, you can configure the destination for the
resulting data. This data will be run through the postprocessor prior to being
written to the destination.

## Common configuration options

| Option          | Default | Required | Description                                                                          |
|-----------------|---------|----------|--------------------------------------------------------------------------------------|
| type            |         | YES      | The type of destination to use. Should be the name of one of the destinations below. |
| export_file[^1] |         | YES      | Path to the JSON export from Senzing.                                                |

## CSV

Write records to a CSV file with optional headers.

### Configuration

The following options are available for this destination.

| Option    | Default | Required | Description                                             |
|-----------|---------|----------|---------------------------------------------------------|
| path      |         | YES      | The path to write the CSV file.                         |
| overwrite | false   | NO       | Overwrite the existing file instead of appending to it. |
| headers   | [ ]     | NO       | List of headers to write to the CSV file.               |

### Example

```yaml
destination:
  type: CSV
  path: /home/senzing/export.csv
  overwrite: true
  headers:
    - person_id
    - database
    - party_id
    - match_score
    - potential_person_id
    - potential_match_score
  export_file: /home/senzing/export.json
```

## Mongo

Write records to a [MongoDB][mongo] collection as individual JSON documents.

### Configuration

The following options are available for this destination.

| Option     | Default | Required | Description                                               |
|------------|---------|----------|-----------------------------------------------------------|
| hosts      | [ ]     | YES      | List of hosts with port to connect to.                    |
| username   |         | YES      | Username to authenticate with.                            |
| password   |         | YES      | Password to authenticate with.                            |
| database   | people  | NO       | The name of the database that records will be added to.   |
| collection | people  | NO       | The name of the collection that records will be added to. |

### Example

```yaml
destination:
  type: Mongo
  database: people
  collection: people
  hosts:
    - "127.0.0.1:27017"
  username: root
  password: ********
  export_file: /home/senzing/export.json
```

Check out the [Export to Mongo][mongo-example] to see this in action.

## JSONL

Write records to a [JSON Lines][jsonl] formatted file. Each record will be
written as a single JSON object each on their own line.

### Configuration

The following options are available for this destination.

| Option    | Default | Required | Description                                             |
|-----------|---------|----------|---------------------------------------------------------|
| path      |         | YES      | The path to write the JSONL file.                       |
| overwrite | false   | NO       | Overwrite the existing file instead of appending to it. |

### Example

```yaml
destination:
  type: JSONL
  path: /home/senzing/export.csv
  overwrite: false
  export_file: /home/senzing/export.json
```

[jsonl]: https://jsonlines.org/
[mongo]: https://www.mongodb.com/
[mongo-example]: examples/export-to-mongo.md
[^1]: Use of an export file is temporary until records can be exported directly
using the API.
