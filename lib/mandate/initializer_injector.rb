require 'securerandom'

module Mandate
  NO_DEFAULT = SecureRandom.uuid
  CAPTURE_KWARGS_ATTR = :attributes

  module InitializerInjector
    def self.extended(base)
      class << base
        def initialize_with(*attrs, **kwattrs, &block)
          define_method :initialize do |*args, **kwargs|
            # If the last attribute is :attributes, store the kwargs array
            # instead of its individual keyword values
            if attrs.last == CAPTURE_KWARGS_ATTR
              args << kwargs
              kwargs = []
            end

            unless args.length == attrs.length
              raise ArgumentError, "wrong number of arguments (given #{args.length}, expected #{attrs.length})"
            end

            attrs.zip(args).each do |attr, arg|
              instance_variable_set("@#{attr}", arg)
            end

            kwargs.each do |name, value|
              raise ArgumentError, "unknown keyword: #{name}" unless kwattrs.key?(name)

              instance_variable_set("@#{name}", value)
            end

            kwattrs.each do |key, value|
              next unless value == NO_DEFAULT
              next if kwargs.key?(key)

              raise ArgumentError, "Keyword argument was not specified: #{key}"
            end

            instance_eval(&block) if block
          end

          attrs.each do |attr|
            define_method attr do
              instance_variable_get("@#{attr}")
            end
            private attr
          end

          kwattrs.each do |attr, default|
            define_method attr do
              if instance_variable_defined?("@#{attr}")
                instance_variable_get("@#{attr}")
              else
                default
              end
            end
            private attr
          end
        end
      end
    end
  end
end
