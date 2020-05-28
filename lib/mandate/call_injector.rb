module Mandate
  module CallInjector
    def self.extended(base)
      # Defining call allows us to do use the syntax:
      #   Foobar.(some, args)
      # which internally calls:
      #   Foobar.new(some, args).call()
      class << base
        def call(*args)
          if args.last.is_a?(Hash) && 
            :key == instance_method(:initialize).parameters.last&.first
            new(*args[0..-2], **args[-1]).call
          else
            new(*args).call
          end
        end
      end
    end
  end
end

