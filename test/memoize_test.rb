require "test_helper"

class MandateTest < Minitest::Test

  class MemoizeTester
    include Mandate

    attr_reader :normal_1_call_count, :memoize_call_count, :normal_2_call_count
    def initialize
      @normal_1_call_count = 0
      @memoize_call_count = 0
      @normal_2_call_count = 0
    end

    def normal_1_iterate
      @normal_1_call_count += 1
    end

    memoize
    def memoize_iterate
      @memoize_call_count += 1
    end

    def normal_2_iterate
      @normal_2_call_count += 1
    end
  end

  def test_it_memoizes_as_required
    tester = MemoizeTester.new
    3.times do
      tester.normal_1_iterate
      tester.memoize_iterate
      tester.normal_2_iterate
    end

    assert_equal 3, tester.normal_1_call_count
    assert_equal 3, tester.normal_2_call_count
    assert_equal 1, tester.memoize_call_count
  end
end

