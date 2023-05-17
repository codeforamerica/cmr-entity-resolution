# Example: Export to Mongo

This example demonstrates exporting data to a [MongoDB][mongo] database.
Following the steps below will import a sample CSV file into Senzing before
exporting the resulting data. If you choose to import your own CSV file, ensure
that you also provide an appropriate configuration file rather than the one
specified here.

> _Note: All commands listed in this document are run from the root directory of
> this [repository][repo]._

## Launching

If you've launched the entity resolution system by following
[README.md][readme:launching], then you're already part way there! If you haven't,
don't worry! It's worth taking a look at that documentation, but you don't have
to run any of those commands. We'll launch the system along with our MongoDB
containers.

Before launching, there are a number of environment variables that can be set to
configure the containers:

| Variable                   | Default | Description                              |
|----------------------------|---------|------------------------------------------|
| MONGO_INITDB_ROOT_PASSWORD | mongodb | Password for the Mongo root user.        |
| MONGO_INITDB_ROOT_USERNAME | root    | User name for the Mongo root user.       |
| MONGO_UI_EDITOR_THEME      | darcula | Theme used for the Mongo Express editor. |

Whether you already have the entity resolution system up and you just want to
add the Mongo containers, or your need to launch the full stack, you can do so
with the following:

```bash
docker compose \
  -f docker-compose.yml \
  -f docs/examples/assets/docker-compose.mongodb.yml \
  up -d
```

This will launch and configure all the required containers.

## Importing

Now that we have the system up and running, we can import our data. We'll do so
by copying the file into the appropriate directory, setting the configuration
file path, and running the importer.

See [README.md][readme:import] for more information on importing and exporting. 

```bash
cp docs/examples/assets/import.csv data/import/import.csv
export IMPORTER_CONFIG_FILE="$(pwd)/docs/examples/assets/config.mongo.yml"
docker compose up importer
```

Once the importer container exits, your data is now in Senzing!

## Exporting

Now what we're here for! We have our data in Senzing, but we want to get it out
and into MongoDB. Similar to import, we can use the exporter container!

```bash
export EXPORTER_CONFIG_FILE="$(pwd)/docs/examples/assets/config.mongo.yml"
docker compose up exporter
```

## Checking out the data

When we launched the Mongo containers, that included a container running
[Mongo Express][mongo-express]. You can connect at http://localhost:8081 to see
your data in MongoDB.

[mongo]: https://www.mongodb.com/
[mongo-express]: https://github.com/mongo-express/mongo-express
[readme:import]: ../../README.md#importing--exporting
[readme:launching]: ../../README.md#launching
[repo]: https://github.com/codeforamerica/cmr-entity-resolution
