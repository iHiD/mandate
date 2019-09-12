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

  def test_on_success_works_properly
    cmd = Sumer.(10, 5, true)
    cmd.on_success { |res| assert_equal 15, res }
    cmd.on_failure { flunk } # This block should never be called
  end

  def test_on_failure_works_properly
    cmd = Sumer.(10, 5, false)
    cmd.on_success { flunk } # This block should never be called
    cmd.on_failure do |errors|
      assert_equal errors, ["Something bad happened"]
    end
  end

  def test_multiple_errors
    cmd = MultipleErrors.()
    cmd.on_success { flunk } # This block should never be called
    cmd.on_failure do |errors|
      assert_equal errors,  [
        "Something bad happened",
        "Something else bad happened"
      ]
    end
  end

  def test_chaining
    res1 = Sumer.(10, 5, true)
    res2 = res1.on_success { |res| assert_equal 15, res }
    res3 = res1.on_failure { flunk }

    assert_equal res1, res2
    assert_equal res1, res3
    assert_equal res2, res3
  end

  def test_succeededd_and_success
    assert Sumer.(10, 5, true).succeeded?
    assert Sumer.(10, 5, true).success?
    refute Sumer.(10, 5, false).succeeded?
    refute Sumer.(10, 5, false).success?
  end

end
