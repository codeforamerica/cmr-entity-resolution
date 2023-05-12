# Configuring Senzing

This system integrates with Senzing using its [REST API][api].

## Configuration

The following options can be configured for the Senzing connection.

| Option      | Default   | Required | Description                                               |
|-------------|-----------|----------|-----------------------------------------------------------|
| data_source | PEOPLE    | NO       | The data source to use for record storage.                |
| host        | localhost | NO       | The Senzing host to connect to.                           |
| port        | 8250      | NO       | The port to connect to Senzing on.                        |
| tls         | true      | NO       | Whether or not to use TLS[^1] for connections to Senzing. |

## Example

```yaml
senzing:
  host: api.example.com
  port: 8250
  data_source: PEOPLE
  tls: false
```

[api]: https://editor.swagger.io/?url=https://raw.githubusercontent.com/Senzing/senzing-rest-api/main/senzing-rest-api.yaml
[^1]: Transport Layer Security
