module Mandate
  module Callbacks
    class AbortError < RuntimeError
    end

    class Results
      attr_reader :result, :errors

      def initialize
        @succeeded = false
        @errors = []
      end

      def succeeded!(result)
        @result = result
        @succeeded = true
      end

      def add_error(error)
        errors << error
      end

      def succeeded?
        !!succeeded
      end
      alias_method :success?, :succeeded?

      def on_success(&block)
        block.call(result) if succeeded?
        self
      end

      def on_failure(&block)
        block.call(errors) unless succeeded?
        self
      end

      private
      attr_reader :succeeded
    end

    def self.included(base)
      # Override self.call to call the internal call_with_callbacks
      # function which returns a method with on_success/on_failure callbacks
      class << base
        # Remove the existing created by the "include Mandate"
        remove_method(:call)

        # Define a new call methods which calls the instance call
        # method but with the added callbacks needed for on_success/on_failure
        def call(*args)
          new(*args).call_with_callbacks
        end
      end

      base.extend(Callbacks)
    end

    def self.extended(base)
      base.send(:define_method, :call_with_callbacks) do
        begin
          # Create results object
          @__mandate_results = Results.new

          # Run the actual command
          # If call fails, succeeded! will never get called
          @__mandate_results.succeeded!(call)
        rescue AbortError
        end

        @__mandate_results
      end

      private

      base.send(:define_method, :add_error!) do |error|
        @__mandate_results.add_error(error)
      end

      base.send(:define_method, :abort!) do |error = nil|
        add_error!(error) if error
        raise AbortError
      end

      base.send(:define_method, :abort_if_errored!) do
        raise AbortError if @__mandate_results.errors.size > 0
      end
    end
  end
end
