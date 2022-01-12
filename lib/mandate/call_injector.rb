module Mandate
  module CallInjector
    def self.extended(base)
      # Defining call allows us to do use the syntax:
      #   Foobar.(some, args)
      # which internally calls:
      #   Foobar.new(some, args).call()
      class << base
        def call(...)
          new(...).()
        end
      end
    end
  end
end
