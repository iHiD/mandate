module Mandate
  module Callbacks
    class AbortError < RuntimeError
    end

    def self.included(base)
      # Override self.call to call the internal call_with_callbacks
      # function which returns a method with success/failure callbacks
      class << base
        # Remove the existing created by the "include Mandate"
        remove_method(:call)

        # Define a new call methods which calls the instance call
        # method but with the added callbacks needed for success/failure
        def call(*args)
          new(*args).call_with_callbacks
        end
      end

      base.extend(Callbacks)
    end

    def self.extended(base)
      base.define_method(:call_with_callbacks) do

        # Setup
        @__mandate_errors = []
        @__mandate_success = false

        # Run the actual command
        @__mandate_result = call

        # It's succeed so let's set this flag
        @__mandate_success = true
        self

      rescue AbortError
        self
      end

      base.define_method(:success) do |&block|
        return unless @__mandate_success
        block.call(@__mandate_result)
      end

      base.define_method(:failure) do |&block|
        return if @__mandate_success
        block.call(@__mandate_errors)
      end

      private

      base.define_method(:add_error!) do |error|
        @__mandate_errors << error
      end

      base.define_method(:abort!) do |error = nil|
        add_error!(error) if error
        raise AbortError
      end

      base.define_method(:abort_if_errored!) do
        raise AbortError if @__mandate_errors.size > 0
      end
    end
  end
end
