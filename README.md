# Mandate
[![Build Status](https://travis-ci.org/ThalamusAI/mandate.svg?branch=master)](https://travis-ci.org/ThalamusAI/mandate)

A simple command-pattern helper gem for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mandate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mandate

## Usage

```ruby
class SomeService
  import Mandate

  attr_reader :some_number, :some_string
  def initialize(some_number, some_string)
    @some_number, @some_string
  end

  def call
    # Do something that returns the results of this command.
  end

  memoize
  def some_method_to_memoize
    sleep(10)
    "Hello, world!"
  end
end

SomeService.(10, "foobar")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ThalamusAI/mandate.
