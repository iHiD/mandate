# Mandate

![Tests](https://github.com/iHiD/mandate/workflows/Tests/badge.svg)

A simple command-pattern helper gem for Ruby.

**Note: As of 2.0.0, Mandate only supports Ruby 3.x. For Ruby 2.x, please use the 1.0.0 release.**

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

  initialize_with :number_1, number_2: 0

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
Keyword arguments can be expressed normally, but arguments without default values must be specified with the value `Mandate::NO_DEFAULT`.
You may also use the `Mandate::KWARGS` param to capture any params that aren't explicitely set.
The call also takes a block, which is run after the variables are set.

For example, this...

```ruby
MODELS = ...

class Car
  initialize_with :model, color: "blue", owner: Mandate::NO_DEFAULT, params: Mandate::KWARGS do
    raise unless MODELS[model].colors.include?(color)
  end
end
```

...is the equivalent of...

```ruby
MODELS = ...

class Foobar
  def initialize(model, color: "blue", owner:, params = {})
    @model = model
    @color = color
    @owner = owner
    @params = params

    raise unless MODELS[model].colors.include?(color)
  end

  private
  attr_reader :model, :color, :owner
end
```

### Using on_success/on_failure callbacks

Sometimes it is helpful for the class to return on_success/on_failure callbacks rather than just the resulting value.
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

res = Sumer.(1,2)
res.on_success { |result| p result } # puts 3
res.on_failure { |errors| p errors } # Noop
res.succeeded? # true
res.result # 3
res.errors # []

res = Sumer.("1","2")
res.on_success { |result| p result } # Noop
res.on_failure { |errors| p errors } # puts ["num1 must be an Integer"]

res = Sumer.("1","2")
res.on_failure { |errors| p errors } # puts ["num1 must be an Integer", "num2 must be an Integer"]
res.errors # ["num1 must be an Integer", "num2 must be an Integer"]
```

It is also possible to chain methods, for example:

```ruby
Sumer.(1,2).
  on_success { |result| p result }.
  on_failure { |errors| p errors }
```

The `succeeded?` method is also aliased as `success?`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iHiD/mandate.
