# RightScale API Tools

## Installation

Install the latest RubyGem from RubyGems.org:

  `gem install rs-api-tools`
  
For more information, see https://rubygems.org/gems/rs-api-tools.

## Configuration

The toolset currently uses both right_api_client and rest_connection.
Eventually any commands using rest_connection will be upgraded to use right_api_client and rest_connection may only be used for LCP accounts and/or API 1.0.

### right_api_client

Configure ` ~/.rightscale/right_api_client.yml` as per example, https://github.com/rightscale/right_api_client/blob/master/config/login.yml.example.

### rest_connection

Configure ~/.rest_connection/rest_api_config.yaml as per https://github.com/rightscale/rest_connection#usage-instructions.

Copying and editing the example (https://github.com/rightscale/rest_connection/blob/master/config/rest_api_config.yaml.sample) is probably the easiest method.

License and Authors
===================

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