# KaniLaser

[SendGrid v3 Mail Send API](https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html) Ruby Client that validates API request body using [JSON Schema](https://github.com/winebarrel/kani_laser/blob/master/lib/kani_laser/schema.rb).

[![Gem Version](https://badge.fury.io/rb/kani_laser.svg)](http://badge.fury.io/rb/kani_laser)
[![Build Status](https://travis-ci.org/winebarrel/kani_laser.svg?branch=master)](https://travis-ci.org/winebarrel/kani_laser)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kani_laser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kani_laser

## Usage

```ruby
require 'kani_laser'

client = KaniLaser::Client.new(api_key: 'ZAPZAPZAP')

# see https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html
client.send_mail(
  personalizations: [
    {
      to: [
        {
          email: 'john@example.com'
        }
      ],
      subject: 'Hello, World!'
    }
  ],
  from: {
    email: 'from_address@example.com'
  },
  content: [
    {
      type: 'text/plain',
      value: 'Hello, World!'
    }
  ]
)
```

### For testing

```ruby
client = KaniLaser::Client.new(options) do |faraday|
  faraday.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
    stub.post('/v3/mail/send') do |_env|
      [202, {}, '']
    end
  end
end

client.send_mail(...)
```

### Use `On-Behalf-Of`

```ruby
KaniLaser::Client.new(options) do |faraday|
  faraday.headers['On-Behalf-Of'] = '<subuser_username>'
end
```

## Request parameter validation error example

```ruby
# Parameter
{
  personalizations: [{ to: [{ email: 'sugawara@winebarrel.jp' }] }],
  subject: 'Hello, World!',
  from: { email: 'from_address@example.com' },
  content: [{ value: 'Hello, World!' }],
}
```

```
JSON::Schema::ValidationError: The property '#/content/0' did not contain a required property of 'type'
```

## Update schema

```sh
rake schema:update
```

## Related Links

* https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html
* https://sendgrid.api-docs.io/
* https://github.com/sendgrid/sendgrid-oai/
