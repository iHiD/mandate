def ruby2_keywords(*); end if RUBY_VERSION < "2.7"

module Mandate
  module CallInjector
    def self.extended(base)
      # Defining call allows us to do use the syntax:
      #   Foobar.(some, args)
      # which internally calls:
      #   Foobar.new(some, args).call()
      class << base
        # Support Ruby 2 and 3 style positional and keyword arguments handling
        # See https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/
        ruby2_keywords def call(*args, &block)
          new(*args, &block).()
        end
      end
    end
  end
end
