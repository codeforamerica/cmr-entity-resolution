# Importing & Exporting

Data can be imported from a number of [sources] and exported to several
[destinations]. Before you begin, you will need a configuration file with
settings for your source, destination, [filters], and [transformations].

> [!NOTE]
> All commands listed in this document are run from the root directory of
> this project.
 
## Using the CLI

Before you can use the CLI[^1] you will need to install dependencies. If you're
not used to working with Ruby, we recommend installing the Ruby Version Manager
([RVM][rvm]) to manage your rubies.

Make sure you have a supported version of Ruby installed (3.2+) and run the
following to install dependencies:

```bash
bundle install --binstubs
```

The `--binstubs` flag will create executables that can be used without
`bundle exec`.

You can now run the importer and exporter using the CLI. Make sure you pass the
correct path of your configuration file to `--config`.

### Importer

```bash
./bin/importer import --config config/config.yml
```

#### Concurrency
The importer processes records concurrently. You can control the number of threads:
  - **CLI flag**: `--concurrency 8`
  - **Environment variable**: `IMPORT_CONCURRENCY=8`
  - **config.yml**: add top-level value such as `concurrency: 8`

By default, the importer is configured for 4 threads.

#### Re-importing from scratch
If your source data changes or if you need to replace the source in your config,
it is usually a good practice to start the import process from scratch to ensure
validity of the results. Purging the Senzing repository clears out previously
imported records so they don't linger or conflict with the new data, while
leaving your Senzing configuration (data sources, etc.) intact.

Senzing includes an interactive tool, `G2Command.py`, that can be used to purge
the repository.

> [!CAUTION]
> Purging the repository permanently deletes all previously loaded records and
> entities. Before running it, make sure nothing else is connected to Senzing
> (the importer, exporter, API server, redoer, etc. should all be stopped).

```bash
python3 /opt/senzing/g2/python/G2Command.py
```

Once you're at the `(g2cmd)` prompt, run the following and confirm with `y`
when prompted:

```
purgeRepository
```

Once the purge completes, you can run the importer as described above.

> [!NOTE]
> If you're running this project [via Docker][using-docker], see
> [Purging the repository][purging-the-repository] below for the
> Docker-specific steps.

### Exporter

```bash
./bin/exporter export --config config/config.yml
```

## Using docker

You can avoid installing and managing dependencies by running the importer and
exporter using the included container and compose file for docker. Make sure you
set `IMPORTER_CONFIG_FILE` and `EXPORTER_CONFIG_FILE` to the location of your
configuration, otherwise it will look for the default of `config/config.yml`.

### Importer

```bash
export IMPORTER_CONFIG_FILE="$(pwd)/config/config.yml"
docker compose up importer
```

### Exporter

```bash
export EXPORTER_CONFIG_FILE="$(pwd)/config/config.yml"
docker compose up exporter
```

### Purging the repository

To [purge the Senzing repository][re-importing-from-scratch] when running via
Docker, use the bundled `tools` container to reach `G2Command.py`:

```bash
docker compose up -d tools
docker compose exec tools python3 /opt/senzing/g2/python/G2Command.py
```

> [!CAUTION]
> Purging the repository permanently deletes all previously loaded records and
> entities. Make sure any other services connected to Senzing (`api`,
> `importer`, `exporter`, `cmr-api`, `webapp`, `redoer`) are stopped first.

Once you're at the `(g2cmd)` prompt, run `purgeRepository` and confirm with `y`
as described above.

## Using the API

While the importer and exporter tools are great for large operations, you may
want to add and update records on an ongoing basis. The [API][api] provides an
endpoint to import individual records.

[api]: api.md
[destinations]: destinations.md
[filters]: filters.md
[purging-the-repository]: #purging-the-repository
[re-importing-from-scratch]: #
[rvm]: http://rvm.io/
[sources]: sources.md
[transformations]: transformations.md
[using-docker]: #using-docker
[^1]: Command Line Interface
