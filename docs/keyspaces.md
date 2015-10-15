# Keyspaces Documentation

The following methods are provided for updating data within a keyspace.

## `Reflect::Keyspace#append`

Appends a record or multiple records to a tablet. If the tablet doesn't exist
it will be created. records can be either a single object or an array of
objects. A single object represents a single row.

### Parameters

* **key** - The key for the tablet you're appending to.
* **records** - The records to append to the tablet.

### Example

```
require 'reflect'

client = Reflect::Client.new("<API Token>")
keyspace = client.keyspace('my-keyspace-slug')
keyspace.append("my-key", { column1: "Hello", column2: "World" })
```

## `Reflect::Keyspace#replace`

Replaces the existing records in a tablet with a new set of records.  The
`records` parameter can be either a single object or an array of objects. A
single object represents a single row.

### Parameters

* **key** - The key for the tablet you're appending to.
* **records** - The records to append to the tablet.

### Example

```
require 'reflect'

client = Reflect::Client.new("<API Token>")
keyspace = client.keyspace('my-keyspace-slug')
keyspace.replace("my-key", { column1: "Hello", column2: "World" })
```

## `Reflect::Keyspace#patch`

Patches the existing records in a tablet with the set of supplied records. The
`criteria` parameter indicates which records to match existing records on.  In
the Reflect API, if no existing records match the supplied records then those
records are dropped.

### Parameters

* **key** - The key for the tablet you're appending to.
* **records** - The records to append to the tablet.
* **criteria** - An array of field names within a record to match.

### Example

```
require 'reflect'

client = Reflect::Client.new("<API Token>")
keyspace = client.keyspace('my-keyspace-slug')
keyspace.replace("my-key", { column1: "Hello", column2: "World" }, ["column1"])
```
