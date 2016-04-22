[![Stories in Ready](https://badge.waffle.io/mattstratton/guacamole-cookbook.png?label=ready&title=Ready)](https://waffle.io/mattstratton/guacamole-cookbook)
# guacamole

Installs and configures [guacamole](http://guac-dev.org), a clientless remote desktop gateway.

To try it out, do a `kitchen converge` and then load up [http://localhost:8080/guacamole](http://localhost:8080/guacamole). Log in with the username `student1` and password `chef`. The winnode may or may not work, depending on if Matt still has it online.

## Requirements
### Platforms
- Ubuntu 14.04

### Dependencies
- tomcat

## Attributes
* `node['guacamole']['version']` - the version of guacamole to install

## License & Authors
- Author: Matt Stratton (<mattstratton@chef.io>)
- Author: Ian Henry (<ihenry@chef.io>)

```text
Copyright:: 2015, Matt Stratton

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
