# Sources

When importing data into Senzing, you can configure one or more sources for the
data. [Filters] and [transformations] will be run on each record from the source
before it is inserted into Senzing. 

In addition to the configuration options below, the senzing client can be
configured. See [Configuring Senzing][senzing-config] for more information.

## Common configuration options

| Option    | Default | Required | Description                                                                |
|-----------|---------|----------|----------------------------------------------------------------------------|
| field_map | [ ]     | NO       | A mapping of fields from the source to their Senzing counterparts.         |
| name      | $type   | NO       | Name of the source. Defaults to the value of `type`.                       |
| type      |         | YES      | The type of source to use. Should be the name of one of the sources below. |

Senzing uses a [generic entity specification][entity-spec] as their expected
format for records. If the field names in your source data _do not_ match those
defined in the specification, you _must_ define an appropriate `field_map`.

## CSV

Read records from a local CSV file.

### Configuration

The following options are available for this source.

| Option | Default | Required | Description               |
|--------|---------|----------|---------------------------|
| path   |         | YES      | The path to the CSV file. |

### Example

```yaml
sources:
  - type: CSV
    path: /home/senzing/import.csv
    field_map:
      party_id: RECORD_ID
      last_name: PRIMARY_NAME_LAST
      first_name: PRIMARY_NAME_FIRST
      gender: GENDER
      birth_date: DATE_OF_BIRTH
      dr_lic_num: DRIVERS_LICENSE_NUMBER
      dr_lic_state: DRIVERS_LICENSE_STATE
      ssn: SSN_NUMBER
```

## Informix

Query an [IBM Informix][informix] database for records to import.

### Configuration

The following options are available for this source.

| Option   | Default   | Required | Description                                                                   |
|----------|-----------|----------|-------------------------------------------------------------------------------|
| database |           | YES      | Database to read from.                                                        |
| host     |           | YES      | Informix host to connect to.                                                  |
| password |           | YES      | Password for the database user.                                               |
| security | nil       | NO       | Set to "SSL" in order to utilize TLS[^1].                                     |
| schema   | $username | NO       | Schema that the database is attached to. Defaults to the value of `username`. |
| table    |           | YES      | Table that contains the records to be imported                                |
| username |           | YES      | User with access to the database                                              |

### Example

```yaml
sources:
  - type: Informix
    host: localhost
    database: people
    table: people
    username: informix
    password: password
    field_map:
      party_id: RECORD_ID
      last_name: PRIMARY_NAME_LAST
      first_name: PRIMARY_NAME_FIRST
      gender: GENDER
      birth_date: DATE_OF_BIRTH
      dr_lic_num: DRIVERS_LICENSE_NUMBER
      dr_lic_state: DRIVERS_LICENSE_STATE
      ssn: SSN_NUMBER
```
Check out the [Import from Informix][informix-example] to see this in action.

[entity-spec]: https://senzing.zendesk.com/hc/en-us/articles/231925448-Generic-Entity-Specification-Data-Mapping
[filters]: filters.md
[informix]: https://www.ibm.com/products/informix
[informix-example]: examples/import-from-informix.md
[senzing-config]: configuring-senzing.md
[transformations]: transformations.md
[^1]: Transport Layer Security
