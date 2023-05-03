# CMR Entity Resolution

An entity resolution solution for automated record clearance.

## Dependencies

- Docker or Docker Desktop with compose v2 enabled.

## Creating and running an environment

### Launching

This solution is provided as a [docker compose][docker-compose] file and can be
launched locally by running the following command:

*Note: If you would like to launch the webapp to search for entities using a web
interface, you will need to add `-p webapp` to include the `webapp` profile.*

```bash
docker compose up -d
```

The configuration uses a persistent volume for the database and message queue
containers to ensure data is persisted through updates to the image or
configuration.

### Applying changes

In order to apply changes made to docker configurations, you will need to run the
same command used for launching above. This will cause any containers that have
changed to be recreated.

You can also apply changes to single container by adding it to the container.
For example, to apply changes to the api container only you would run the
following:

```bash
docker compose up -d api
```

### Stopping and starting

The environment can be safely stopped and restarted without loss of data.
Stopping, starting, and restarting does not apply pending changes. Use the
command below with the appropriate subcommand for your desired action:

```bash
docker compose [stop|start|restart]
```

### Terminating

To terminate the local environment you can run the following command:

*Note: If you would like to keep the persistent volumes, omit the `--volumes`
flag.*

```bash
docker compose down --volumes
```

## Importing & exporting

The `loader` and `exporter` containers can be used to import records and
export entity matches. These containers mount the contents of `data/import` and
`data/export` from the root of this repository, respectively.

See the [documentation][processing] on pre and postprocessing for information
on how to format your configuration file.

### Importing

Make sure the file to be imported is in a CSV format and place it at
`data/import/import.csv`. Your configuration file for preprocessing should be at
`config/config.yml`; however, this can be overridden by setting the
`LOADER_CONFIG_FILE` environment variable to the local path.

Launch the loader container by running the following:

```bash
docker up -d loader
```

This will build the container (if needed) and run the preprocessor before
importing records into Senzing. The preprocessed file can be found at
`data/import/import.json`.

### Exporting

Your configuration file for postprocessing should be at `config/config.yml`;
however, this can be overridden by setting the `EXPORTER_CONFIG_FILE`
environment variable to the local path.

_Note: You can use the same configuration file for imports and exports._

Launch the exporter container by running the following:

```bash
docker up -d exporter
```

This will build the container (if needed), export the records from senzing, then
run the postprocessor to create the entity match file. The export can be found
at `data/export/export.json` and the entity match file can be found at
`data/export/matches.csv`.

### Manual import & export

You can use the `tools` container to perform manual imports and exports. See
the [additional documentation][manual-import-export] for more information.

## Examples

See our [collection of examples][examples] to see a demonstration of the system
in action.

[docker-compose]: https://docs.docker.com/compose/
[entity-spec]: https://senzing.zendesk.com/hc/en-us/articles/231925448-Generic-Entity-Specification-Data-Mapping
[examples]: docs/examples.md
[manual-import-export]: docs/manual-import-export.md
[processing]: docs/processing.md#config
