# CMR Entity Resolution

An entity resolution solution for automated record clearance.

## Dependencies

- Docker or Docker Desktop with compose v2 enabled.

## Creating and running an environment

### Launching

This solution is provided as a [docker compose][docker-compose] file and can be
launched locally by running the following command:

> [!NOTE]
> If you would like to launch the webapp to search for entities using a web
> interface, you will need to add `-p webapp` to include the `webapp` profile.

```bash
docker compose up -d
```

The configuration uses a persistent volume for the database and message queue
container to ensure data is persisted through updates to the image or
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

Data can be imported and exported using either the included CLI command or
docker container. See [Importing & Exporting][import-export] for more
information on how to get data in and out of Senzing.

## Examples

See our [collection of examples][examples] to see a demonstration of the system
in action.

## Documentation

Necessary documentation to operate, use, maintain, and contribute to this
solution is included in this repository. The majority of these documents are
written in Markdown and can be rendered directly in GitHub or you favorite IDE.
However, the documentation as a whole is meant to be converted to a static site
using [MkDocs].

In order to view the documentation in its intended form locally, you can use the
included docker container. Simply run the following:

```bash
docker compose --profile docs up -d
```

The documentation should then be available at <http://localhost:8000>.

[docker-compose]: https://docs.docker.com/compose/
[entity-spec]: https://senzing.zendesk.com/hc/en-us/articles/231925448-Generic-Entity-Specification-Data-Mapping
[examples]: docs/examples.md
[mkdocs]: https://www.mkdocs.org/
[import-export]: docs/importing-exporting.md
