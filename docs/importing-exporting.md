# Importing & Exporting

Data can be imported from a number of [sources] and exported to several
[destinations]. Before you begin, you will need a configuration file with
settings for your source and [filters] (importing) and/or your destination and
[transformations] (exporting).

> _Note: All commands listed in this document are run from the root directory of
> this project._
 
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

### Exporter

```bash
./bin/exporter export --config config/config.yml
````

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

[destinations]: destinations.md
[filters]: filters.md
[rvm]: http://rvm.io/
[sources]: sources.md
[transformations]: transformations.md
[^1]: Command Line Interface
