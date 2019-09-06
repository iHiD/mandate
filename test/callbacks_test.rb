require "test_helper"

class InitializerInjectorTest < Minitest::Test
  class Sumer
    include Mandate
    include Mandate::Callbacks

    initialize_with :foo, :bar, :succeed

    def call
      if succeed
        abort_if_errored! # This should be a noop
        foo + bar
      else
        abort!("Something bad happened")
      end
    end
  end

  class MultipleErrors
    include Mandate
    include Mandate::Callbacks

    def call
      add_error!("Something bad happened")
      add_error!("Something else bad happened")
      abort_if_errored!
    end
  end

  def test_success_works_properly
    cmd = Sumer.(10, 5, true)
    cmd.success { |res| assert_equal 15, res }
    cmd.failure { flunk } # This block should never be called
  end

  def test_failure_works_properly
    cmd = Sumer.(10, 5, false)
    cmd.success { flunk } # This block should never be called
    cmd.failure do |errors|
      assert_equal errors, ["Something bad happened"]
    end
  end

  def test_multiple_errors
    cmd = MultipleErrors.()
    cmd.success { flunk } # This block should never be called
    cmd.failure do |errors|
      assert_equal errors,  [
        "Something bad happened",
        "Something else bad happened"
      ]
    end
  end

end
