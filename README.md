# RightScale API Tools

[![Gem Version](https://fury-badge.herokuapp.com/rb/rs-api-tools.png)](http://badge.fury.io/rb/rs-api-tools)

## Installation

Ruby >= 1.9.1 is required.

Install the latest RubyGem from RubyGems.org:

  `gem install rs-api-tools`
  
For more information, see https://rubygems.org/gems/rs-api-tools.

### Mac OS X

Receiving error: `mkmf.rb can't find header files for ruby at /System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/lib/ruby/include/ruby.h`

You must have Xcode and Xcode Command Line Tools installed to build the native extensions of the gem.
This can be carried out either by `Xcode > Preferences > Downloads` or issuing `xcode-select --install` in Terminal.app.
You may also need to open Xcode after installation to complete the install.

## Configuration

The toolset currently uses both `right_api_client` and `rest_connection`.
Eventually any commands using rest_connection will be upgraded to use right_api_client and rest_connection may only be used for LCP accounts and/or API 1.0.

### right_api_client

Copy https://github.com/rightscale/right_api_client/blob/master/config/login.yml.example to `~/.rightscale/right_api_client.yml`. Edit the file, providing your RightScale user credentials including account ID.

You may need to create the `.rightscale` folder in your home directory first.

### rest_connection

Configure RestConnection as per https://github.com/rightscale/rest_connection#usage-instructions.

Copying and editing https://github.com/rightscale/rest_connection/blob/master/config/rest_api_config.yaml.sample to `~/.rest_connection/rest_api_config.yaml` is recommended.

## Usage

The toolset provides many commands to interface RightScale's API. Upon install of the RubyGem, you should find all the commands within path.
Each command starts with the "rs-" prefix. Use the `--help` option with each command, e.g. `rs-describe-instances --help`.

### Metadata consumers

A subset of the tools can use a YAML or JSON file describing RightScale objects to carry out operations with the data.
The commands will accept a `--metadata` option which can be a file location/path or http[s] URL.

#### Creating ServerTemplates

An example `rightscale.yaml` defining a ServerTemplate including name, description, tags, cookbooks, inputs, boot scripts, MCIs and alerts.
(https://github.com/chef-blueprints/linux_box/blob/master/rightscale.yaml)

Create the ServerTemplate:

```sh
rs-create-servertemplate --metadata \
  https://raw.github.com/chef-blueprints/linux_box/master/rightscale.yaml
```

#### Creating Deployments

An example `rightscale.yaml` defining a deployment with a single server from the MultiCloud Marketplace
(https://github.com/rightscale-meta/deployments/blob/master/base_servertemplate_for_linux_v13.5.yaml)

```yaml
deployment:
  name: Base ServerTemplate for Linux v13.5
  description: A deployment containing only a Base ServerTemplate for Linux v13.5
    server.
  server_tag_scope: account
  servers:
  - name: Base ServerTemplate for Linux v13.5
    server_template:
      publication_id: 177541
    cloud_id: 1
```

Create the deployment:

```sh
rs-create-deployment --metadata \
  https://raw.github.com/rightscale-meta/deployments/master/base_servertemplate_for_linux_v13.5.yaml
```

More definitions are located at https://github.com/rightscale-meta/deployments/
  
## License and Authors

* Author:: Chris Fordham <chris [at] fordham [hyphon] nagy [dot] id [dot] au>

* Copyright:: 2011-2013, Chris Fordham

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.