module Mandate
  module Memoize
    def memoize
      @__mandate_memoizing = true
    end

    def method_added(method_name)
      super
      return unless @__mandate_memoizing

      memoizer = Module.new do
        p method_name
        define_method method_name do
          @__mandate_memoized_results ||= {}

          if @__mandate_memoized_results.include?(method_name)
            @__mandate_memoized_results[method_name]
          else
            @__mandate_memoized_results[method_name] = super()
          end
        end
      end

      prepend memoizer

      @__mandate_memoizing = false
    end
  end
end

