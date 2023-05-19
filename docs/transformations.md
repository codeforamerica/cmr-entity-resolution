# Transformations

The following transformations can be added to your configuration file for both
imports and exports. They can be applied to individual sources and destinations
to allow for more flexibility.

For example:

```yaml
sources:
  - type: CSV
    ...
    transformations:
      - transform: StaticValue
        field: SOURCE
        value: "Court CSV"
  - type: CSV
    ...
    transformations:
      - transform: StaticValue
        field: SOURCE
        value: "Repository CSV"
```

## SplitValue

This transformation will split the value of a field on a delimiter. Each part
of the split value can be signed to different fields individually.

### Configuration

The following options are available for this transformation.

| Option    | Default | Required | Description                          |
|-----------|---------|----------|--------------------------------------|
| field     |         | YES      | The field to be split.               |
| parts     |         | YES      | Where to save the different parts.   |
| delimiter | ,       | NO       | The delimiter to split the value on. |

The `parts` option should specify each index to be saved along with the field to
save that part to.

### Example

```yaml
- transform: SplitValue
  field: RECORD_ID
  delimiter: "-"
  parts:
    0: DATABASE
    1: PARTY_ID
```

Note that if a part is empty, that field's value will be set to `nil`.

## StaticValue

This transformation will set a static value into a field.

### Configuration

The following options are available for this transformation.

| Option  | Default | Required | Description                         |
|---------|---------|----------|-------------------------------------|
| field   |         | YES      | The field to set the value into.    |
| value   |         | YES      | Static value to set into the field. |


### Example

```yaml
- transform: StaticValue
  field: SAMPLE_FIELD
  value: "Sample value"
```
