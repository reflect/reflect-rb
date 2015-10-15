# Keyspace Operations

These are the basic operations to get up and running with the client.

## `Reflect::Client#new`

Instantiate a new version of the Reflect API client.

### Parameters

* **api_token** - The API token to connect to Reflect with.

### Example

```
require 'reflect'

client = Reflect::Client.new("<API Token>")
```

## `Reflect::Client#keyspace`

Load the metadata associated with a keyspace. This is most useful for
performing [Keyspace
operations](https://github.com/reflect/reflect-rb/blob/master/docs/keyspaces.md).

### Parameters

* **slug** - The slug for a Keyspace.

### Example

```
require 'reflect'

KEYSPACE_NAME = "My Keyspace"
KEYSPACE_SLUG = "my-keyspace"

client = Reflect::Client.new("<API Token>")
keyspace = client.keyspace(KEYSPACE_SLUG)
```
