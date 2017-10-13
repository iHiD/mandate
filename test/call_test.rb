require "test_helper"

class CallTest < Minitest::Test

  class Sumer
    include Mandate

    attr_reader :foo, :bar
    def initialize(foo, bar)
      @foo = foo
      @bar = bar
    end

    def call
      return foo + bar
    end
  end

  def test_call_works_properly
    assert_equal 15, Sumer.(10, 5)
  end
end
