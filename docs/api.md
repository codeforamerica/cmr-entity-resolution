# Clear My Record API

The entiity resolution system includes an API that can be used as a proxy to
send records to the Senzing API. The Clear My Record API  can be run as a Docker
container or manually using `rackup`.

## Starting the API

### Configuration

The API uses the same configuration file as the [importer and exporter][config].
Requests to the API must include a `source` property that should match the name
from the configuration file.

For example, if you have the following source in your configuration file, you
would use "parties" as the source property in your request:

```yaml
sources:
  parties:
    type: CSV
    path: /home/senzing/parties.csv
    field_map:
      party_id: RECORD_ID
      ...
```

| Environment Variable | Description                                                                        | Default                |
|----------------------|------------------------------------------------------------------------------------|------------------------|
| `CMR_API_KEY`        | API key used to authenticate with the API. **This must be changed in production.** | `ThisIsTheDefaultKey!` |
| `CMR_API_PORT`       | Local port to bind the API to. _(Docker compose only)_                             | `3000`                 |
| `CMR_CONFIG_FILE`    | Path to the configuration file.                                                    | `config/config.yml`    |

### Running the API manually

You can use `rackup` to run the API locally. Make sure you've installed the
latest dependencies with `bundle install`, and run the following command:

```bash
bundle exec rackup --port 3000
```

_Note: If you don't specify a port, the default port for rack — 9292 — will be
used._

### Running the API via Docker

The bundled [`docker-compose.yml`][compose] file includes a `cmr-api` profile
for the API. When running `docker up`, simply add the `--profile cmr-api` flag
and the API will be started alongside the other services.

## Endpoints

All API endpoints will respond with an JSON object. Supported request formats
include the following:

| Format         | Content-Type       |
|----------------|--------------------|
| JSON (default) | `application/json` |
| CSV            | `text/csv`         |

### GET /health

A basic health endpoint that will return a 200 status code if the API is
running.

_Note: This endpoint does not require authentication._

Example response:

```json
{ "status": "ok" }
```

### POST /import

Import a single record into the Senzing API. The request must be a JSON object
with the `source` property set, in addition to any other properties of the
record.

Example JSON request:

```json
{
  "source": "parties",
  "party_id": "12345",
  "first_name": "John",
  "last_name": "Doe",
  "dob": "1980-01-01"
}
```

Exampple CSV request:

```csv
"source","party_id","first_name","last_name","dob"
"parties","12345","John","Doe","1980-01-01"
```

Example response:

```json
{ "status": "success"}
```

If the request succeeds, the API will return a 201 status code.

[compose]: https://github.com/codeforamerica/cmr-entity-resolution/blob/main/docker-compose.yml
[config]: importing-exporting.md
