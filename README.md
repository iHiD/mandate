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
class Multiplies
  include Mandate

  initialize_with :number_1, :number_2

  def call
    do_the_maths
  end

  # Memoize any method by putting the keyword before it.
  memoize
  def do_the_maths
    sleep(10)
    number_1 * number_2
  end
end

# This calls initializer and then call with the params
Multiplies.(20, 3)
# => 60
```

### `initialize_with`

The `initialize_with` method creates an initializer and private attr_readers for the specified variables.

For example `initialize_with :foo, :bar` is the equivelent of:

```ruby
def initialize(foo, bar)
  @foo = foo
  @bar = bar
end

private
attr_reader :foo, :bar
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iHiD/mandate.
