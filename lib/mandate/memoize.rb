module Mandate
  module Memoize

    # This method is called on the line before a
    # define statement. It puts mandate into memoizing mode
    def memoize
      @__mandate_memoizing = true
    end

    # Intercept a method being added.
    # Create the method as normal, then if we are in
    # memoize mode, call out to the memoize function and
    # reset out of memoizing mode.
    def method_added(method_name)
      super

      if instance_variable_defined?("@__mandate_memoizing") && @__mandate_memoizing
        __mandate_memoize(method_name)
        @__mandate_memoizing = false
      end
    end

    # Create an anonymous module that defines a method
    # with the same name as main method being defined.
    # Add some memoize code to check whether the method
    # has been previously called or not. If it's not
    # been then call the underlying method and store the result.
    #
    # We then prepend this module so that its method
    # comes first in the method-lookup chain.
    def __mandate_memoize(method_name)
      # Capture the access level of the method outside the module
      # then set the method inside the module to have the same
      # access later.
      if private_instance_methods.include?(method_name)
        access_modifier = :private
      elsif protected_instance_methods.include?(method_name)
        access_modifier = :protected
      end

      memoizer = Module.new do
        define_method method_name do
          @__mandate_memoized_results ||= {}

          if @__mandate_memoized_results.include?(method_name)
            @__mandate_memoized_results[method_name]
          else
            @__mandate_memoized_results[method_name] = super()
          end
        end
        
        send(access_modifier, method_name) if access_modifier
      end
      prepend memoizer
    end
  end
end

