# Example: Import from Informix

This example demonstrates importing data from an [IBM Informix][informix]
database. Following the steps below will launch an Informix container locally
and load a sample dataset to be imported into Senzing. You can also use your own
Informix database, but you must also provide an appropriate configuration file
rather than the one specified here.

> [!NOTE]
> All commands listed in this document are run from the root directory of this
> [repository][repo].

## Launching

If you've launched the entity resolution system by following
[README.md][readme:launching], then you're already part way there! If you haven't,
don't worry! It's worth taking a look at that documentation, but you don't have
to run any of those commands. We'll launch the system along with our Informix
container.

Before launching, the following environment variables can be set to configure
the container:

| Variable          | Default  | Description                            |
|-------------------|----------|----------------------------------------|
| INFORMIX_PASSWORD | password | Password for the root "informix" user. |

Whether you already have the entity resolution system up and you just want to
add the Informix container, or your need to launch the full stack, you can do so
with the following:

```bash
docker compose \
  -f docker-compose.yml \
  -f docs/examples/assets/docker-compose.informix.yml \
  up -d
```

This will launch and configure all the required containers and load the sample
dataset into Informix.

## Importing

Now that we have the system up and running, we can import our data. The data's
already been loaded into the Informix database, so we just need to point the
importer at it. We do so using a configuration file with the source set to the 
database, and passing that to the importer.

See [Importing & Exporting][import-export] for more information on importing and
exporting. 

```bash
export IMPORTER_CONFIG_FILE="$(pwd)/docs/examples/assets/config.informix.yml"
docker compose up importer
```

Once the importer container exits, your data is now in Senzing!

## Exporting

To verify that the import succeeded, we can export the results from Senzing
to a CSV file. Our config file already has this setup.

```bash
export EXPORTER_CONFIG_FILE="$(pwd)/docs/examples/assets/config.informix.yml"
docker compose up exporter
```

[import-export]: ../importing-exporting.md
[informix]: https://www.ibm.com/products/informix
[readme:launching]: /#launching
[repo]: https://github.com/codeforamerica/cmr-entity-resolution
