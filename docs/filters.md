# Filters

The following filters can be added to your configuration file for preprocessing.

## NonHuman

This filter will attempt to remove entities. that are non-human, such as
corporations or other organizations. The filter searches for keywords within
different part of the entity's name.

These keywords can be found in [`non_human.yml`][non_human].

### Configuration

This filter has no configuration options.

### Example

```yaml
  - filter: NonHuman 
```

Alternatively, since there are no configuration options, you can use the short
form:

```yaml
  - NonHuman
```

## ValueIs

This filter will compare a field's value with a static value and can be used to
include a record if the value does or does not match.

### Configuration

The following options are available for this filter.

| Option  | Default | Required | Description                              |
|---------|---------|----------|------------------------------------------|
| field   |         | YES      | The field to be evaluated.               |
| value   |         | YES      | Static value for comparison.             |
| inverse | false   | NO       | Set to true for a not equals comparison. |

### Example

```yaml
- filter: ValueIs
  field: TYPE
  value: DEF
  inverse: false
```

[non_human]: ../lib/filter/non_human.yml
