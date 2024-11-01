# Destinations

When exporting data from Senzing, you can configure the destination for the
resulting data. [Transformations] will be run on each record from the export
before it is sent to the destination.

## Common configuration options

| Option          | Default | Required | Description                                                                          |
|-----------------|---------|----------|--------------------------------------------------------------------------------------|
| export_file[^1] |         | YES      | Path to the JSON export from Senzing.                                                |
| field_map       |         | YES      | A mapping of fields from Senzing to their counterparts in the destination.           |
| type            |         | YES      | The type of destination to use. Should be the name of one of the destinations below. |

## CSV

Write records to a CSV file with optional headers.

### Configuration

The following options are available for this destination.

| Option    | Default | Required | Description                                             |
|-----------|---------|----------|---------------------------------------------------------|
| headers   | [ ]     | NO       | List of headers to write to the CSV file.               |
| overwrite | false   | NO       | Overwrite the existing file instead of appending to it. |
| path      |         | YES      | The path to write the CSV file.                         |

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
  field_map:
    ENTITY_ID: person_id
    DATABASE: database
    PARTY_ID: party_id
    MATCH_SCORE: match_score
    RELATED_RECORD_ID: potential_person_id
    RELATED_MATCH_SCORE: potential_match_score
  export_file: /home/senzing/export.json
```

## JSONL

Write records to a [JSON Lines][jsonl] formatted file. Each record will be
written as a single JSON object each on their own line.

### Configuration

The following options are available for this destination.

| Option    | Default | Required | Description                                             |
|-----------|---------|----------|---------------------------------------------------------|
| overwrite | false   | NO       | Overwrite the existing file instead of appending to it. |
| path      |         | YES      | The path to write the JSONL file.                       |

### Example

```yaml
destination:
  type: JSONL
  path: /home/senzing/export.csv
  overwrite: false
  field_map:
    ENTITY_ID: person_id
    DATABASE: database
    PARTY_ID: party_id
    MATCH_SCORE: match_score
    RELATED_RECORD_ID: potential_person_id
    RELATED_MATCH_SCORE: potential_match_score
  export_file: /home/senzing/export.json
```

## Mongo

Write records to a [MongoDB][mongo] collection as individual JSON documents.

### Configuration

The following options are available for this destination.

| Option     | Default | Required | Description                                               |
|------------|---------|----------|-----------------------------------------------------------|
| collection | people  | NO       | The name of the collection that records will be added to. |
| database   | people  | NO       | The name of the database that records will be added to.   |
| hosts      | [ ]     | YES      | List of hosts with port to connect to.                    |
| password   |         | YES      | Password to authenticate with.                            |
| username   |         | YES      | Username to authenticate with.                            |

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
  field_map:
    ENTITY_ID: person_id
    DATABASE: database
    PARTY_ID: party_id
    MATCH_SCORE: match_score
    RELATED_RECORD_ID: potential_person_id
    RELATED_MATCH_SCORE: potential_match_score
  export_file: /home/senzing/export.json
```

Check out the [Export to Mongo][mongo-example] to see this in action.

## MySQL

Insert entities into a [MySQL] or compatible (such as [MariaDB]) database.

### Configuration

The following options are available for this source.

| Option   | Default   | Required | Description                                |
|----------|-----------|----------|--------------------------------------------|
| database |           | YES      | Database to write to.                      |
| host     |           | YES      | Database host to connect to.               |
| password |           | YES      | Password for the database user.            |
| port     | 3306      | NO       | Port to connect to on the database server. |
| security | nil       | NO       | Set to "SSL" in order to utilize TLS[^2].  |
| table    |           | YES      | Table to write entities to.                |
| username |           | YES      | User with access to the database.          |

### Example

```yaml
sources:
  informix:
    type: MySQL
    host: localhost
    database: people
    table: entity_resolution
    username: mysql
    password: password
    field_map:
      ENTITY_ID: person_id
      DATABASE: database
      PARTY_ID: party_id
      MATCH_SCORE: match_score
      RELATED_RECORD_ID: potential_person_id
      RELATED_MATCH_SCORE: potential_match_score
    export_file: /etc/cmr/export/export.json
```

Check out the [Import from MySQL][mysql-example] to see this in action.

[jsonl]: https://jsonlines.org/
[mariadb]: https://mariadb.org/
[mongo]: https://www.mongodb.com/
[mongo-example]: examples/export-to-mongo.md
[mysql]: https://www.mysql.com/
[transformations]: transformations.md
[^1]: Use of an export file is temporary until records can be exported directly
using the API.
[^2]: Transport Layer Security
