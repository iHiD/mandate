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

For example `initialize_with :foo, :bar` is the equivalent of:

```ruby
def initialize(foo, bar)
  @foo = foo
  @bar = bar
end

private
attr_reader :foo, :bar
```

### Using success/failure callbacks

Sometimes it is helpful for the class to return success/failure callbacks rather than just the resulting value.
This can be achieved by including the `Mandate::Callbacks` module as follows:

```ruby
class Sumer
  include Mandate
  include Mandate::Callbacks

  initialize_with :num1, :num2

  def call
    abort!("num1 must be an Integer") unless num1.is_a?(Integer)
    abort!("num2 must be an Integer") unless num2.is_a?(Integer)

    num1 + num2
  end
end

cmd = Sumer.(1,2)
cmd.success{ |result| p result }
cmd.failure{ |errors| p errors }
# => 3

cmd = Sumer.("1","2")
cmd.success{ |result| p result }
cmd.failure{ |errors| p errors }
# => ["num1 must be an Integer"]
```

Rather than using `abort!` with an error, it is also possible to add errors as you go then abort if you find any. 
For example:

```ruby
class Sumer
  include Mandate
  include Mandate::Callbacks

  initialize_with :num1, :num2

  def call
    add_error!("num1 must be an Integer") unless num1.is_a?(Integer)
    add_error!("num2 must be an Integer") unless num2.is_a?(Integer)
    abort_if_errored!

    num1 + num2
  end
end

cmd = Sumer.(1,2)
cmd.success{ |result| p result }
cmd.failure{ |errors| p errors }
# => 3

cmd = Sumer.("1","2")
cmd.success{ |result| p result }
cmd.failure{ |errors| p errors }
# => ["num1 must be an Integer", "num2 must be an Integer"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iHiD/mandate.
