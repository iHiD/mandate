module Mandate
  module CallInjector
    def self.extended(base)
      # Defining call allows us to do use the syntax:
      #   Foobar.(some, args)
      # which internally calls:
      #   Foobar.new(some, args).call()
      class << base
        def call(*args)
          # If the last argument is a hash and the last param is a keyword params (signified by
          # its type being :key, the we should pass the hash in in using the **kwords syntax.
          # This fixes a deprecation issue in Ruby 2.7.
          if args.last.is_a?(Hash) &&
             instance_method(:initialize).parameters.last&.first == :key
            new(*args[0..-2], **args[-1]).()
          else
            new(*args).()
          end
        end
      end
    end
  end
end
