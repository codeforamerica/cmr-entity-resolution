# Pre & Postprocessing

Your source data isn't likely to match the format required by Senzing. To
address, we've dev loped pre and postprocessing tools that can be configured for
different use cases.

## Dependencies

In order to run these tools locally you will need the following:

- Ruby 3.2.1+

With Ruby installed, you can install software dependencies by running:

```bash
bundle install
bundle binstubs cmr-entity-resolution
```

## Usage

Both tools can be found in the bin directory. You can run them locally using the
following:

```bash
./bin/preprocess process
./bin/postprocess process
```

You can view the documentation for each by calling help before the command. For
example:

```bash
./bin/preprocess help process
```

Each command takes the following options:

| Option   | Default                 | Description                           |
|----------|-------------------------|---------------------------------------|
| --config | $ROOT/config/config.yml | Path to the configuration file.       |
| --input  | $PWD/import.csv         | CSV file to be imported into Senzing. |
| --output | $PWD/senzing_input.json | Output file after being processed.    |

## Config

See the [sample][sample-config] file for basic configuration options.

Check the documentation for [filters][filters] and
[transformations][transformations] for more advanced options.

[filters]: filters.md
[sample-config]: ../config/config.sample.yml
[transformations]: transformations.md
