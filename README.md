# Reflect Ruby Client

A ruby wrapper for the Reflect API. The current iteration is specifically
geared for uploading data, but full support for the API is planned. If there
are features that are missing, feel free to open an issue or even a pull
request!

## Documentation

The [docs](https://github.com/reflect/reflect-rb/blob/master/docs) directory
has the current set of documentation.

## Example

```ruby
require 'reflect'

data = [
  {
    customer_id: "customer1",
    widget_id: "widget1",
    manufactured: "Ohio",
    temperature: 150
  },
  {
    customer_id: "customer1",
    widget_id: "widget2",
    manufactured: "Ohio",
    temperature: 50
  }
]

client = Reflect::Client.new("<Your API Token>")
keyspace = client.keyspace("demo-keyspace")
keyspace.replace("my-tablet", data)
```

## Support

Reach out to [ReflectHQ on Twitter](https://twitter.com/reflecthq) or file an
issue here if you have questions or issues.
