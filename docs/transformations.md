# Transformations

The following transformations can be added to your configuration file for
postprocessing.

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
save that part to. For example:

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
