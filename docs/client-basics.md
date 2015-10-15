# The Basics

These are the basic operations to get up and running with the client.

## `Reflect::Client#new(api_token)`

Instantiate a new version of the Reflect API client.

### Parameters

* **api_token** - The API token to connect to Reflect with.

### Example

```ruby
require 'reflect'

client = Reflect::Client.new("<API Token>")
```

## `Reflect::Client#keyspace(slug)`

Load the metadata associated with a keyspace. This is most useful for
performing [Keyspace
operations](https://github.com/reflect/reflect-rb/blob/master/docs/keyspaces.md).

### Parameters

* **slug** - The slug for a Keyspace.

### Example

```ruby
require 'reflect'

KEYSPACE_NAME = "My Keyspace"
KEYSPACE_SLUG = "my-keyspace"

client = Reflect::Client.new("<API Token>")
keyspace = client.keyspace(KEYSPACE_SLUG)
```
