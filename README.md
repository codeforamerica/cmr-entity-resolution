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

The `tools` container can be used to interact with Senzing using the G2 python
library. Some commands below will require a terminal open to the `tools`
container. This can be done directly through Docker Desktop or by running the
following command:

```bash
docker compose exec tools /bin/bash
```

*Note: The `tools` container does not have a persistent volume. Any changes made
in the container will be lost if the container is recreated or removed.*

### Project setup

Before you can import or export data you will need to create a project by
running the following on the container (you can use any project name you wish):

```bash
G2CreateProject.py project
```

This will create a directory with the name of the project in the `senzing`
user's home directory. Before running commands from any of the steps below,
you will need to be using a configured project by running the following:

```bash
cd ~/project
source setupEnv
```

### Importing

You can copy a CSV or JSON file to the container in order to be imported into
Senzing. With a file that conforms to the
[Generic Entity Specification][entity-spec], run the following on your local
host:

```bash
docker compose cp /path/to/import.json tools:/home/senzing/.
```

From the project directory on the container, run the following for a JSON file:

*Note: If you would like to first purge existing records, you can add the `-P`
flag to the command below.*

```bash
G2Loader.py -f ../import.json/?data_source=PEOPLE,file_format=JSON
```

For a CSV file:

```bash
G2Loader.py -f ../import.csv/?data_source=PEOPLE,file_format=CSV
```

### Exporting

You can export the resolved entities to a JSON file on the container which can
then be copied to your local host. To run the export, run the following from the
project directory on the container:

```bash
G2Export.py -o ../senzing_output.json -F json -x -f=0
```

Run the following from your local host to copy the file:

```bash
docker compose cp tools:/home/senzing/senzing_output.json /path/to/destination/. 
```

## Pre and postprocessing

Your source data isn't likely to match the format required by Senzing. To
address, we've dev loped pre and postprocessing tools that can be configured for
different use cases.

### Dependencies

In order to run these tools locally you will need the following:

- Ruby 3.2.1+

With Ruby installed, you can install software dependencies by running:

```bash
bundle install
```

### Usage

Both tools can be found in the bin directory. You can run them locally using the
following:

```bash
bundle exec bin/preprocess process
bundle exec bin/postprocess process
```

You can view the documentation for each by calling help before the command. For
example:

```bash
bundle exec bin/preprocess help process
```

Each command takes the following options:

| Option   | Default                 | Description                          |
|----------|-------------------------|--------------------------------------|
| --config  | $ROOT/config/config.yml   | Path to the conmfiguration file.       |
| --input  | $PWD/import.csv         | CSV file to be imported into Senzing. |
| --output | $PWD/senzing_input.json | Output file after being processed.    |

### Config

See the [sample][sample-config] file for basic configuration options.

Check the documentation for [filters][filters] and
[transformations][transformations] for more advanced options.

[docker-compose]: https://docs.docker.com/compose/
[entity-spec]: https://senzing.zendesk.com/hc/en-us/articles/231925448-Generic-Entity-Specification-Data-Mapping
[filters]: docs/filters.md
[sample-config]: config/config.sample.yml
[transformations]: docs/transformations.md
