require 'securerandom'

module Mandate
  NO_DEFAULT = SecureRandom.uuid
  KWARGS = SecureRandom.uuid

  module InitializerInjector
    def self.extended(base)
      class << base
        def initialize_with(*attrs, **kwattrs, &block)
          kwarg_capture_key = (kwattrs.find(-> { [] }) { |_name, value| value == KWARGS }).first

          define_method :initialize do |*args, **kwargs|
            unless args.length == attrs.length
              raise ArgumentError, "wrong number of arguments (given #{args.length}, expected #{attrs.length})"
            end

            attrs.zip(args).each do |attr, arg|
              instance_variable_set("@#{attr}", arg)
            end

            instance_variable_set("@#{kwarg_capture_key}", {}) if kwarg_capture_key
            kwargs.each do |name, value|
              if kwattrs.key?(name)
                instance_variable_set("@#{name}", value)
              elsif kwarg_capture_key
                instance_variable_get("@#{kwarg_capture_key}")[name] = value
              else
                raise ArgumentError, "unknown keyword: #{name}"
              end
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
