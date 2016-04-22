# apt-chef

[![Build Status](https://travis-ci.org/chef-cookbooks/apt-chef.svg?branch=master)](https://travis-ci.org/chef-cookbooks/apt-chef) [![Cookbook Version](https://img.shields.io/cookbook/v/apt-chef.svg)](https://supermarket.chef.io/cookbooks/apt-chef)

Sets up the default apt package repository for Chef Software, Inc. products.

Primarily intended to be consumed by the chef-ingredient cookbook.

## Requirements

### Platforms

- Only supports Ubuntu. May work on other Debian-family distributions. Other platforms don't make sense with apt repositories.  However, not all platforms that this cookbook will work on have supported packages from the repository. See [supported platforms](https://docs.chef.io/supported_platforms.html). Users may need to override attributes in roles or wrapper cookbooks to get this to work, or write their own cookbooks entirely.

### Chef

- Chef 11+

### Cookbooks

- apt

## Attributes

The `attributes/default.rb` file contains comments with all the attributes that can be set to control how this cookbook sets up the repository.

## Recipes

### default

Uses the attributes in `attributes/default.rb` to control how the repository is configured.

### current

Hard-codes Chef's public "current" repository. Used for situations where both stable and current repositories are desired.

### stable

Hard-codes Chef's public "stable" repository. Used for situations where both stable and current repositories are desired.

## A Note About Proxies

If an HTTP proxy is required to reach the configured repository, then that can be managed outside this cookbook using an apt preferences file. A very simple example can be rendered with a file resource:

```ruby
file '/etc/apt/apt.conf.d/01proxy' do
  content 'Acquire::http::Proxy "http://proxy.example.com:3128";'
end
```

See the [apt preferences documentation](https://wiki.debian.org/AptConf) for more information and configurable options.

## A Note About Ubuntu 10.04 and unsigned packages

Ubuntu 10.04, unlike later versions, will not install unsigned packages without adding a force option. If you should run into this, you can update your consuming resource as follows:

```ruby
package 'chef-ha' do
  options '--force-yes' if platform?('ubuntu') && node['platform_version'] == '10.04'
end
```

## License & Authors

**Author:** Cookbook Engineering Team ([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2008-2016, Chef Software, Inc.

```
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
