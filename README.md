# Zanobo Rails Common
A collection of useful things to help make it easier to make webapps in Rails.

This is a work in progress.

# Configuration
ZanoboRailsCommon accepts a block for configuration. Best done in a Rails initializer.

```
ZanoboRailsCommon.configure do |config|
  config.authenticate_webhooks = true # false here would allow the webhooks to process without basic auth
  config.webhooks_username = "a basic auth username"
  config.webhooks_password = "a basic auth password"
  config.access_token = "your access token"
  config.preview_access_token = "your preview access token"
  config.space = "your space ID"
  config.options = "hash of options"
end
```

# Usage

# To Do
Some things would be nice to do:
* Populate this todo list : )

# Licence
Undecided

# Contributing
Please feel free to contribute!

* Fork this repo
* Make your changes
* Commit
* Create a PR