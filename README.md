# KaniLaser

[SendGrid v3 Mail Send API](https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html) Ruby Client.

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
