# Manually Importing & Exporting

The `tools` container can be used to interact with Senzing using the G2 python
library. Some commands below will require a terminal open to the `tools`
container. This can be done directly through Docker Desktop or by running the
following command:

```bash
docker compose exec tools /bin/bash
```

*Note: The `tools` container does not have a persistent volume. Any changes made
in the container will be lost if the container is recreated or removed.*

## Pre & postprocessing

See the [documentation][processing] on processing your data before import and
after export to ensure that it's in the expected formats.

## Project setup

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

## Importing

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

## Exporting

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

[processing]: processing.md
