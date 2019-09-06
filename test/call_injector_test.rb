require "test_helper"

class CallInjectorTest < Minitest::Test

  class Sumer
    include Mandate

    attr_reader :foo, :bar
    def initialize(foo, bar)
      @foo = foo
      @bar = bar
    end

    def call
      foo + bar
    end
  end

  class BadConstant
    include Mandate

    def call
      IAmNotDefined
    end
  end

  def test_call_works_properly
    assert_equal 15, Sumer.(10, 5)
  end

  def test_call_works_properly_with_bad_constant
    assert_raises(NameError) do
      BadConstant.()
    end
  end

end
