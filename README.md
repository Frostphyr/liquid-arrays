# Liquid Arrays

Adds better support for arrays and hashes in Liquid. Liquid only comes with 
support for creating arrays using `split` and iteration for arrays and hashes. 
This adds support for standard array and hash operations, such as creation, 
insertion, replacement, and deletion.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'liquid-arrays'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install liquid-arrays

Ensure any other requirements the software you're using might have for loading 
plugins are met.

## Usage

There are several tags that will modify arrays and hashes in various ways. 
Each tag has various attributes that specify information about the operation. 
The syntax for the tags and attributes is as follows:

```liquid
{% tag_name attribute:value attribute:value %}
```

Some tags will have a default attribute which can be used if only one 
attribute needs specified, like so:

```liquid
{% tag_name value %}
```

### array_add tag

Adds a value to the end of an array. If the array doesn't exist, it will 
create it first.

| Attribute | Required                 | Type     | Description         |
| --------- | ------------------------ | -------- | ------------------- |
| array     | If outside `array` block | Variable | The array to modify |
| value     | Yes (default)            | Any      | The value to add    |

#### Example

```liquid
{% assign var = "a" %}
{% array_add array:values value:var %}
{% array_add array:values value:1 %}
{% array_add array:values value:true %}
```

```ruby
values => ["a", 1, true]
```

### array_delete tag

Deletes an index or all occurrences of a value from an array. If an index is 
used, it must be within the interval `[0, length)`.

| Attribute | Required                 | Type     | Description         |
| --------- | ------------------------ | -------- | ------------------- |
| array     | If outside `array` block | Variable | The array to modify |
| index     | If no `value` | Integer or Variable | The index to delete |
| value     | If no `index`            | Any      | The value to delete |

#### Example

```ruby
values => ["a", "b", "c", "a"]
```

```liquid
{% array_delete array:values index:1 %}
{% array_delete array:values value:"a" %}
```

```ruby
values => ["c"]
```

### array_insert tag

Inserts a value into an array at an index. The index must be within the 
interval `[0, length]`. The array must already exist and will not be created 
if it does not.

| Attribute | Required                 | Type     | Description            |
| --------- | ------------------------ | -------- | ---------------------- |
| array     | If outside `array` block | Variable | The array to modify    |
| index     | Yes           | Integer or Variable | The index to insert at |
| value     | Yes                      | Any      | The value to insert    |

#### Example

```ruby
values => ["a", "b", "c"]
```

```liquid
{% array_insert array:values index:0 value:"z" %}
{% array_insert array:values index:2 value:"y" %}
```

```ruby
values => ["z", "a", "y", "b", "c"]
```

### array_replace tag

Replaces the value at an index in an array. The index must be within the 
interval `[0, length)`.

| Attribute | Required                 | Type     | Description               |
| --------- | ------------------------ | -------- | ------------------------- |
| array     | If outside `array` block | Variable | The array to modify       |
| index     | Yes           | Integer or Variable | The index to replace      |
| value     | Yes                      | Any      | The value to replace with |

#### Example

```ruby
values => ["a", "b", "c"]
```

```liquid
{% array_replace array:values index:0 value:"z" %}
{% array_replace array:values index:2 value:"y" %}
```

```ruby
values => ["z", "b", "y"]
```

### array block tag

Allows for the modification of an array without having to specify the array 
for every operation. If the array doesn't exist, it will create an empty array.

| Attribute | Required      | Type     | Description         |
| --------- | ------------- | -------- | ------------------- |
| array     | Yes (default) | Variable | The array to modify |

#### Example

```liquid
{% array values %}
  {% array_add "a" %}
  {% array_add "b" %}
  {% array_insert index:1 value:"z" %}
{% endarray %}
```

```ruby
values => ["a", "z", "b"]
```

### hash_set tag

Sets a key-value mapping in a hash, either adding it if it doesn't already 
exist or replacing the existing mapping for the key. If the hash doesn't 
exist, it will create it first.

| Attribute | Required                | Type     | Description                 |
| --------- | ----------------------- | -------- | --------------------------- |
| hash      | If outside `hash` block | Variable | The hash to modify          |
| key       | Yes                     | Any      | The key to map the value to |
| value     | Yes                     | Any      | The value to map to the key |

#### Example

```liquid
{% hash_set hash:values key:"value1" value:"a" %}
{% hash_set hash:values key:"value2" value:3 %}
{% hash_set hash:values key:"value3" value:false %}
```

```ruby
values => {"value1" => "a", "value2" => 3, "value3" => false}
```

### hash_delete tag

Deletes a key-value mapping from a hash for a key.

| Attribute | Required                | Type     | Description                       |
| --------- | ----------------------- | -------- | --------------------------------- |
| hash      | If outside `hash` block | Variable | The hash to modify                |
| key       | Yes (default)           | Any      | The key to remove the mapping for |

#### Example

```ruby
values => {"value1" => "a", "value2" => 3, "value3" => false}
```

```liquid
{% hash_delete hash:values key:"value1" %}
{% hash_delete hash:values key:"value2" %}
```

```ruby
values => {"value3" => false}
```

### hash block tag

Allows for the modification of a hash without having to specify the hash for  
every operation. If the hash doesn't exist, it will create an empty hash.

| Attribute | Required      | Type     | Description        |
| --------- | ------------- | -------- | ------------------ |
| hash      | Yes (default) | Variable | The hash to modify |

#### Example

```liquid
{% hash values %}
  {% hash_set key:"value1" value:"a" %}
  {% hash_set key:"value2" value:"b" %}
  {% hash_set key:"value3" value:"c" %}
  {% hash_delete "value2" %}
{% endhash %}
```

```ruby
values => {"value1" => "a", "value3" => "c"}
```

## License

Liquid Arrays is licensed under 
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0). It is a 
permissive software license with a few restrictions.

* This software may be modified, used, and distributed in open or 
closed-source software.
* Redistribution requires a copy of the license and notices to any 
modifications made to this software.
* Any unmodified parts of this software must retain the original license but 
any modifications or derivatives may be licensed differently.

This is only a brief summary of the license. For the complete restrictions and 
requirements, please refer to the full license.