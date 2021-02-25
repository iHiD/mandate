module Mandate
  module InitializerInjector
    def self.extended(base)
      class << base
        def initialize_with(*attrs, **kwattrs)
          if kwattrs.empty?
            define_method :initialize do |*args|
              unless args.length == attrs.length
                raise ArgumentError, "wrong number of arguments (given #{args.length}, expected #{attrs.length})"
              end

              attrs.zip(args).each do |attr, arg|
                instance_variable_set("@#{attr}", arg)
              end
            end
          else
            define_method :initialize do |*args, **kwargs|
              unless args.length == attrs.length
                raise ArgumentError, "wrong number of arguments (given #{args.length}, expected #{attrs.length})"
              end

              attrs.zip(args).each do |attr, arg|
                instance_variable_set("@#{attr}", arg)
              end

              kwargs.each do |name, value|
                if kwattrs.key?(name)
                  instance_variable_set("@#{name}", value)
                else
                  raise ArgumentError, "unknown keyword: #{name}"
                end
              end
            end
          end

          attrs.each do |attr|
            define_method attr do instance_variable_get("@#{attr}") end
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
