## 1.1.0

### Features

* Added `array_create` and `hash_create` tags
* Arrays and hashes can now be defined inline to be used as attributes
* Improved error handling to now use Liquid's `error_mode`

### Bug Fixes

* Arrays and hashes will be created in the proper scope instead of the outer-most scope
* Fixed issue when using default attributes that use special characters, like array elements
* Added check to ensure a variable is an array or hash before modifying it to avoid errors