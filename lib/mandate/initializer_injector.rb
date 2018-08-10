module Mandate
  module InitializerInjector
    def self.extended(base)
      class << base
        def initialize_with(*attrs)
          define_method :initialize do |*args|
            unless args.length == attrs.length
              raise ArgumentError.new("Wrong number of arguments (given #{args.length}, expected #{attrs.length})")
            end

            attrs.zip(args).each do |attr,arg|
              instance_variable_set("@#{attr}", arg)
            end
          end

          attrs.each do |attr|
            define_method attr do instance_variable_get("@#{attr}") end
            private attr
          end
        end
      end
    end
  end
end


