# Example: Import from MySQL

> [!TIP]
> The MySQL source type can be used for any MySQL compatible database, as shown
> in this example using MariaDB.

This example demonstrates importing data from a [MySQL][mysql] database, and
exporting the results to another table in that same database. Following the
steps below will launch a [MariaDB] container locally, and load a sample dataset
to be imported into Senzing. You can also use your own MySQL compatible
database, but you must also provide an appropriate configuration file rather
than the one specified here.

> [!NOTE]
> All commands listed in this document are run from the root directory of this
> [repository][repo].

## Launching

If you've launched the entity resolution system by following
[README.md][readme:launching], then you're already part way there! If you
haven't, don't worry! It's worth taking a look at that documentation, but you
don't have to run any of those commands. We'll launch the system along with our
MariaDB container.

Before launching, the following environment variables can be set to configure
the container:

| Variable              | Default  | Description                 |
|-----------------------|----------|-----------------------------|
| MARIADB_ROOT_PASSWORD | password | Password for the root user. |

Whether you already have the entity resolution system up and you just want to
add the MariaDB container, or your need to launch the full stack, you can do so
with the following:

```bash
docker compose \
  -f docker-compose.yml \
  -f docs/examples/assets/docker-compose.mysql.yml \
  up -d
```

This will launch and configure all the required containers and load the sample
dataset into MariaDB.

## Importing

Now that we have the system up and running, we can import our data. The data's
already been loaded into the database, so we just need to point the importer at
it. We do so using a configuration file with the source set to the database, and
passing that to the importer.

See [Importing & Exporting][import-export] for more information on importing and
exporting. 

```bash
export IMPORTER_CONFIG_FILE="$(pwd)/docs/examples/assets/config.mysql.yml"
docker compose up importer
```

Once the importer container exits, your data is now in Senzing!

## Exporting

With our records imported into Senzing, we can export the resulting entities.
For this example, we'll export the entities to a new table in the same database.

> [!NOTE]
> The export process assumes that the table already exists. For this example,
> we've used the following to create the table:
> ```sql
> CREATE TABLE entity_resolution(
>   person_id VARCHAR(255) NOT NULL,
>   database VARCHAR(255) NOT NULL,
>   party_id VARCHAR(255) NOT NULL,
>   match_score INTEGER NULL,
>   potential_person_id VARCHAR(255) NULL,
>   potential_match_score INTEGER NULL,
>   PRIMARY KEY (person_id, party_id, database)
> );
> ```

```bash
export EXPORTER_CONFIG_FILE="$(pwd)/docs/examples/assets/config.mysql.yml"
docker compose up exporter
```

[import-export]: ../importing-exporting.md
[mariadb]: https://mariadb.org/
[mysql]: https://www.mysql.com/
[readme:launching]: /#launching
[repo]: https://github.com/codeforamerica/cmr-entity-resolution
